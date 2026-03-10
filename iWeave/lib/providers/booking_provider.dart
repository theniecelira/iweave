import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../data/mock_data.dart';

class BookingProvider extends ChangeNotifier {
  List<BookingModel> _bookings = [];
  final List<BookingModel> _sessionBookings = []; // Track bookings created in this session
  bool _isLoading = false;
  bool _hasLoaded = false;

  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;

  Future<void> loadBookings(String userId) async {
    // If already loaded, don't overwrite session bookings
    if (_hasLoaded) return;

    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));

    // Load mock bookings for the user
    final mockUserBookings = mockBookings.where((b) => b.userId == userId).toList();

    // Merge: session bookings first (newest), then mock bookings (avoiding duplicates)
    final sessionIds = _sessionBookings.map((b) => b.id).toSet();
    final mergedBookings = [
      ..._sessionBookings,
      ...mockUserBookings.where((b) => !sessionIds.contains(b.id)),
    ];

    _bookings = mergedBookings;
    _hasLoaded = true;
    _isLoading = false;
    notifyListeners();
  }

  /// Force reload bookings (e.g., after login with different user)
  Future<void> reloadBookings(String userId) async {
    _hasLoaded = false;
    _sessionBookings.clear();
    await loadBookings(userId);
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
    await Future.delayed(const Duration(milliseconds: 1000));
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

    // Add to both session bookings and active bookings
    _sessionBookings.insert(0, booking);
    _bookings.insert(0, booking);
    notifyListeners();
    return booking;
  }

  void cancelBooking(String bookingId) {
    final idx = _bookings.indexWhere((b) => b.id == bookingId);
    if (idx != -1) {
      final old = _bookings[idx];
      final cancelled = BookingModel(
        id: old.id,
        userId: old.userId,
        itemId: old.itemId,
        itemName: old.itemName,
        itemImage: old.itemImage,
        type: old.type,
        status: BookingStatus.cancelled,
        bookingDate: old.bookingDate,
        checkIn: old.checkIn,
        checkOut: old.checkOut,
        guests: old.guests,
        totalAmount: old.totalAmount,
      );
      _bookings[idx] = cancelled;

      // Also update in session bookings if present
      final sessionIdx = _sessionBookings.indexWhere((b) => b.id == bookingId);
      if (sessionIdx != -1) {
        _sessionBookings[sessionIdx] = cancelled;
      }

      notifyListeners();
    }
  }
}