import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/booking_model.dart';
import '../models/order_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'iweave.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE bookings (
            id TEXT PRIMARY KEY,
            userId TEXT NOT NULL,
            itemId TEXT NOT NULL,
            itemName TEXT NOT NULL,
            itemImage TEXT NOT NULL,
            type TEXT NOT NULL,
            status TEXT NOT NULL,
            bookingDate TEXT NOT NULL,
            checkIn TEXT,
            checkOut TEXT,
            guests INTEGER NOT NULL,
            totalAmount REAL NOT NULL,
            notes TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE orders (
            id TEXT PRIMARY KEY,
            userId TEXT NOT NULL,
            userName TEXT NOT NULL,
            userEmail TEXT NOT NULL,
            status TEXT NOT NULL,
            orderDate TEXT NOT NULL,
            subtotal REAL NOT NULL,
            shippingFee REAL NOT NULL,
            totalAmount REAL NOT NULL,
            shippingAddress TEXT,
            notes TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE order_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderId TEXT NOT NULL,
            productId TEXT NOT NULL,
            productName TEXT NOT NULL,
            productImage TEXT NOT NULL,
            weaverName TEXT NOT NULL,
            quantity INTEGER NOT NULL,
            unitPrice REAL NOT NULL,
            totalPrice REAL NOT NULL,
            selectedMaterial TEXT,
            selectedColor TEXT,
            selectedDesign TEXT,
            giftWrap INTEGER DEFAULT 0,
            giftMessage TEXT,
            giftFrom TEXT,
            giftTo TEXT,
            FOREIGN KEY (orderId) REFERENCES orders(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            role TEXT NOT NULL DEFAULT 'tourist',
            phone TEXT,
            avatarUrl TEXT,
            address TEXT,
            createdAt TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE users ADD COLUMN avatarUrl TEXT');
        }
      },
    );
  }

  // ─── BOOKINGS ─────────────────────────────────────────────────────────────

  Future<void> insertBooking(BookingModel b) async {
    final db = await database;
    await db.insert(
      'bookings',
      {
        'id': b.id,
        'userId': b.userId,
        'itemId': b.itemId,
        'itemName': b.itemName,
        'itemImage': b.itemImage,
        'type': b.type.name,
        'status': b.status.name,
        'bookingDate': b.bookingDate.toIso8601String(),
        'checkIn': b.checkIn?.toIso8601String(),
        'checkOut': b.checkOut?.toIso8601String(),
        'guests': b.guests,
        'totalAmount': b.totalAmount,
        'notes': b.notes,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BookingModel>> getBookings({String? userId}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;

    if (userId != null) {
      maps = await db.query(
        'bookings',
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: 'bookingDate DESC',
      );
    } else {
      maps = await db.query('bookings', orderBy: 'bookingDate DESC');
    }

    return maps.map(_bookingFromMap).toList();
  }

  Future<void> updateBookingStatus(String id, BookingStatus status) async {
    final db = await database;
    await db.update(
      'bookings',
      {'status': status.name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteBooking(String id) async {
    final db = await database;
    await db.delete('bookings', where: 'id = ?', whereArgs: [id]);
  }

  BookingModel _bookingFromMap(Map<String, dynamic> m) {
    return BookingModel(
      id: m['id'],
      userId: m['userId'],
      itemId: m['itemId'],
      itemName: m['itemName'],
      itemImage: m['itemImage'],
      type: BookingType.values.firstWhere((e) => e.name == m['type']),
      status: BookingStatus.values.firstWhere((e) => e.name == m['status']),
      bookingDate: DateTime.parse(m['bookingDate']),
      checkIn: m['checkIn'] != null ? DateTime.parse(m['checkIn']) : null,
      checkOut: m['checkOut'] != null ? DateTime.parse(m['checkOut']) : null,
      guests: m['guests'],
      totalAmount: (m['totalAmount'] as num).toDouble(),
      notes: m['notes'],
    );
  }

  // ─── ORDERS ───────────────────────────────────────────────────────────────

  Future<void> insertOrder(OrderModel order) async {
    final db = await database;

    await db.insert(
      'orders',
      {
        'id': order.id,
        'userId': order.userId,
        'userName': order.userName,
        'userEmail': order.userEmail,
        'status': order.status.name,
        'orderDate': order.orderDate.toIso8601String(),
        'subtotal': order.subtotal,
        'shippingFee': order.shippingFee,
        'totalAmount': order.totalAmount,
        'shippingAddress': order.shippingAddress,
        'notes': order.notes,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    for (final item in order.items) {
      await db.insert('order_items', {
        'orderId': order.id,
        'productId': item.productId,
        'productName': item.productName,
        'productImage': item.productImage,
        'weaverName': item.weaverName,
        'quantity': item.quantity,
        'unitPrice': item.unitPrice,
        'totalPrice': item.totalPrice,
        'selectedMaterial': item.selectedMaterial,
        'selectedColor': item.selectedColor,
        'selectedDesign': item.selectedDesign,
        'giftWrap': item.giftWrap ? 1 : 0,
        'giftMessage': item.giftMessage,
        'giftFrom': item.giftFrom,
        'giftTo': item.giftTo,
      });
    }
  }

  Future<List<OrderModel>> getOrders({String? userId}) async {
    final db = await database;
    final List<Map<String, dynamic>> orderMaps;

    if (userId != null) {
      orderMaps = await db.query(
        'orders',
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: 'orderDate DESC',
      );
    } else {
      orderMaps = await db.query('orders', orderBy: 'orderDate DESC');
    }

    final orders = <OrderModel>[];

    for (final om in orderMaps) {
      final itemMaps = await db.query(
        'order_items',
        where: 'orderId = ?',
        whereArgs: [om['id']],
      );

      final items = itemMaps
          .map(
            (m) => OrderItemModel(
              productId: m['productId'] as String,
              productName: m['productName'] as String,
              productImage: m['productImage'] as String,
              weaverName: m['weaverName'] as String,
              quantity: m['quantity'] as int,
              unitPrice: (m['unitPrice'] as num).toDouble(),
              totalPrice: (m['totalPrice'] as num).toDouble(),
              selectedMaterial: m['selectedMaterial'] as String?,
              selectedColor: m['selectedColor'] as String?,
              selectedDesign: m['selectedDesign'] as String?,
              giftWrap: m['giftWrap'] == 1,
              giftMessage: m['giftMessage'] as String?,
              giftFrom: m['giftFrom'] as String?,
              giftTo: m['giftTo'] as String?,
            ),
          )
          .toList();

      orders.add(
        OrderModel(
          id: om['id'] as String,
          userId: om['userId'] as String,
          userName: om['userName'] as String,
          userEmail: om['userEmail'] as String,
          status: OrderStatus.values.firstWhere((e) => e.name == om['status']),
          orderDate: DateTime.parse(om['orderDate'] as String),
          items: items,
          subtotal: (om['subtotal'] as num).toDouble(),
          shippingFee: (om['shippingFee'] as num).toDouble(),
          totalAmount: (om['totalAmount'] as num).toDouble(),
          shippingAddress: om['shippingAddress'] as String?,
          notes: om['notes'] as String?,
        ),
      );
    }

    return orders;
  }

  Future<void> updateOrderStatus(String id, OrderStatus status) async {
    final db = await database;
    await db.update(
      'orders',
      {'status': status.name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ─── USERS ────────────────────────────────────────────────────────────────

  Future<void> upsertUser(Map<String, dynamic> user) async {
    final db = await database;

    final safeUser = {
      'id': user['id'],
      'name': user['name'],
      'email': user['email'],
      'role': user['role'] ?? 'tourist',
      'phone': user['phone'],
      'avatarUrl': user['avatarUrl'],
      'address': user['address'],
      'createdAt': user['createdAt'],
    };

    await db.insert(
      'users',
      safeUser,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return db.query('users', orderBy: 'createdAt DESC');
  }

  Future<Map<String, dynamic>?> getUserById(String id) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return result.first;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return result.first;
  }

  Future<void> deleteUser(String id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // ─── STATS ────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getAdminStats() async {
    final db = await database;

    final bookingCount =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM bookings')) ??
            0;
    final orderCount =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders')) ?? 0;
    final userCount =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM users')) ?? 0;

    final bookingRevenue = (await db.rawQuery(
      'SELECT SUM(totalAmount) as total FROM bookings WHERE status != "cancelled"',
    )).first['total'];

    final orderRevenue = (await db.rawQuery(
      'SELECT SUM(totalAmount) as total FROM orders WHERE status != "cancelled"',
    )).first['total'];

    return {
      'totalBookings': bookingCount,
      'totalOrders': orderCount,
      'totalUsers': userCount,
      'bookingRevenue': (bookingRevenue as num?)?.toDouble() ?? 0.0,
      'orderRevenue': (orderRevenue as num?)?.toDouble() ?? 0.0,
      'totalRevenue':
          ((bookingRevenue as num?)?.toDouble() ?? 0.0) +
          ((orderRevenue as num?)?.toDouble() ?? 0.0),
    };
  }

  Future<void> seedInitialData() async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM users'));

    if ((count ?? 0) > 0) return;

    final now = DateTime.now();

    for (final u in [
      {
        'id': 'u1',
        'name': 'Maria Santos',
        'email': 'tourist@iweave.ph',
        'role': 'tourist',
        'phone': null,
        'avatarUrl': null,
        'address': null,
        'createdAt': now.subtract(const Duration(days: 30)).toIso8601String(),
      },
      {
        'id': 'u2',
        'name': 'Nanay Rosa',
        'email': 'weaver@iweave.ph',
        'role': 'weaver',
        'phone': null,
        'avatarUrl': null,
        'address': null,
        'createdAt': now.subtract(const Duration(days: 60)).toIso8601String(),
      },
      {
        'id': 'u3',
        'name': 'Admin User',
        'email': 'admin@iweave.ph',
        'role': 'admin',
        'phone': null,
        'avatarUrl': null,
        'address': null,
        'createdAt': now.subtract(const Duration(days: 90)).toIso8601String(),
      },
      {
        'id': 'u4',
        'name': 'Demo User',
        'email': 'demo@demo.com',
        'role': 'tourist',
        'phone': null,
        'avatarUrl': null,
        'address': null,
        'createdAt': now.subtract(const Duration(days: 7)).toIso8601String(),
      },
    ]) {
      await upsertUser(u);
    }
  }
}