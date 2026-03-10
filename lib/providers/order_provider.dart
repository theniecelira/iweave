import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../services/database_service.dart';

class OrderProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  /// Load orders for a specific user, or ALL orders if userId is null (admin)
  Future<void> loadOrders({String? userId}) async {
    _isLoading = true;
    notifyListeners();
    _orders = await _db.getOrders(userId: userId);
    _isLoading = false;
    notifyListeners();
  }

  /// Place a new order from cart items
  Future<OrderModel> placeOrder({
    required String userId,
    required String userName,
    required String userEmail,
    required List<CartItem> cartItems,
    required double subtotal,
    required double shippingFee,
    String? shippingAddress,
  }) async {
    final order = OrderModel(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      status: OrderStatus.pending,
      orderDate: DateTime.now(),
      items: cartItems.map((ci) => OrderItemModel(
        productId: ci.product.id,
        productName: ci.product.name,
        productImage: ci.product.imageUrl,
        weaverName: ci.product.weaverName,
        quantity: ci.quantity,
        unitPrice: ci.product.basePrice,
        totalPrice: ci.totalPrice,
        selectedMaterial: ci.selectedMaterial,
        selectedColor: ci.selectedColor,
        selectedDesign: ci.selectedDesign,
        giftWrap: ci.giftWrap,
        giftMessage: ci.giftMessage,
        giftFrom: ci.giftFrom,
        giftTo: ci.giftTo,
      )).toList(),
      subtotal: subtotal,
      shippingFee: shippingFee,
      totalAmount: subtotal + shippingFee,
      shippingAddress: shippingAddress,
    );

    await _db.insertOrder(order);
    _orders.insert(0, order);
    notifyListeners();
    return order;
  }

  /// Update order status (admin use)
  Future<void> updateStatus(String orderId, OrderStatus newStatus) async {
    await _db.updateOrderStatus(orderId, newStatus);
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      final old = _orders[idx];
      _orders[idx] = OrderModel(
        id: old.id, userId: old.userId, userName: old.userName,
        userEmail: old.userEmail, status: newStatus,
        orderDate: old.orderDate, items: old.items,
        subtotal: old.subtotal, shippingFee: old.shippingFee,
        totalAmount: old.totalAmount,
        shippingAddress: old.shippingAddress, notes: old.notes,
      );
      notifyListeners();
    }
  }
}
