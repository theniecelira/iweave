import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../data/mock_data.dart';
import '../services/database_service.dart';

class BookingProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<BookingModel> _bookings = [];
  bool _isLoading = false;
  bool _seeded = false;

  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;

  /// Load bookings for a specific user. Seeds mock data on first run.
  Future<void> loadBookings(String userId) async {
    _isLoading = true;
    notifyListeners();

    // Seed mock bookings into DB on first ever load
    if (!_seeded) {
      final existing = await _db.getBookings(userId: userId);
      if (existing.isEmpty) {
        for (final b in mockBookings.where((b) => b.userId == userId)) {
          await _db.insertBooking(b);
        }
      }
      _seeded = true;
    }

    _bookings = await _db.getBookings(userId: userId);
    _isLoading = false;
    notifyListeners();
  }

  /// Load ALL bookings across all users (admin use)
  Future<void> loadAllBookings() async {
    _isLoading = true;
    notifyListeners();

    if (!_seeded) {
      final existing = await _db.getBookings();
      if (existing.isEmpty) {
        for (final b in mockBookings) {
          await _db.insertBooking(b);
        }
      }
      _seeded = true;
    }

    _bookings = await _db.getBookings();
    _isLoading = false;
    notifyListeners();
  }

  Future<BookingModel> createBooking({
    required String userId,
    required String itemId,
    required String itemName,
    required String itemImage,
    required BookingType type,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
    required double totalAmount,
    String? notes,
  }) async {
    final booking = BookingModel(
      id: 'b_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      itemId: itemId,
      itemName: itemName,
      itemImage: itemImage,
      type: type,
      status: BookingStatus.confirmed,
      bookingDate: DateTime.now(),
      checkIn: checkIn,
      checkOut: checkOut,
      guests: guests,
      totalAmount: totalAmount,
      notes: notes,
    );

    await _db.insertBooking(booking);
    _bookings.insert(0, booking);
    notifyListeners();
    return booking;
  }

  Future<void> cancelBooking(String bookingId) async {
    await _db.updateBookingStatus(bookingId, BookingStatus.cancelled);
    final idx = _bookings.indexWhere((b) => b.id == bookingId);
    if (idx != -1) {
      final old = _bookings[idx];
      _bookings[idx] = BookingModel(
        id: old.id, userId: old.userId, itemId: old.itemId,
        itemName: old.itemName, itemImage: old.itemImage, type: old.type,
        status: BookingStatus.cancelled, bookingDate: old.bookingDate,
        checkIn: old.checkIn, checkOut: old.checkOut,
        guests: old.guests, totalAmount: old.totalAmount,
      );
      notifyListeners();
    }
  }

  /// Update status to any value (admin use)
  Future<void> updateStatus(String bookingId, BookingStatus newStatus) async {
    await _db.updateBookingStatus(bookingId, newStatus);
    final idx = _bookings.indexWhere((b) => b.id == bookingId);
    if (idx != -1) {
      final old = _bookings[idx];
      _bookings[idx] = BookingModel(
        id: old.id, userId: old.userId, itemId: old.itemId,
        itemName: old.itemName, itemImage: old.itemImage, type: old.type,
        status: newStatus, bookingDate: old.bookingDate,
        checkIn: old.checkIn, checkOut: old.checkOut,
        guests: old.guests, totalAmount: old.totalAmount, notes: old.notes,
      );
      notifyListeners();
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    await _db.deleteBooking(bookingId);
    _bookings.removeWhere((b) => b.id == bookingId);
    notifyListeners();
  }
}