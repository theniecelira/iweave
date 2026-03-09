import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../data/mock_data.dart';

class BookingProvider extends ChangeNotifier {
  List<BookingModel> _bookings = [];
  bool _isLoading = false;

  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;

  Future<void> loadBookings(String userId) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    _bookings = mockBookings.where((b) => b.userId == userId).toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<BookingModel> createBooking({
    required String userId, required String itemId, required String itemName,
    required String itemImage, required BookingType type,
    required DateTime checkIn, required DateTime checkOut,
    required int guests, required double totalAmount, String? notes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final booking = BookingModel(
      id: 'b_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId, itemId: itemId, itemName: itemName, itemImage: itemImage,
      type: type, status: BookingStatus.confirmed,
      bookingDate: DateTime.now(),
      checkIn: checkIn, checkOut: checkOut,
      guests: guests, totalAmount: totalAmount, notes: notes,
    );
    _bookings.insert(0, booking);
    notifyListeners();
    return booking;
  }

  void cancelBooking(String bookingId) {
    final idx = _bookings.indexWhere((b) => b.id == bookingId);
    if (idx != -1) {
      _bookings[idx] = BookingModel(
        id: _bookings[idx].id, userId: _bookings[idx].userId,
        itemId: _bookings[idx].itemId, itemName: _bookings[idx].itemName,
        itemImage: _bookings[idx].itemImage, type: _bookings[idx].type,
        status: BookingStatus.cancelled,
        bookingDate: _bookings[idx].bookingDate,
        checkIn: _bookings[idx].checkIn, checkOut: _bookings[idx].checkOut,
        guests: _bookings[idx].guests, totalAmount: _bookings[idx].totalAmount,
      );
      notifyListeners();
    }
  }
}
