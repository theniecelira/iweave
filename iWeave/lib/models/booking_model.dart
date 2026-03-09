enum BookingStatus { pending, confirmed, completed, cancelled }
enum BookingType { tour, accommodation, product }

class BookingModel {
  final String id;
  final String userId;
  final String itemId;
  final String itemName;
  final String itemImage;
  final BookingType type;
  final BookingStatus status;
  final DateTime bookingDate;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int guests;
  final double totalAmount;
  final String? notes;

  const BookingModel({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.itemName,
    required this.itemImage,
    required this.type,
    required this.status,
    required this.bookingDate,
    this.checkIn,
    this.checkOut,
    required this.guests,
    required this.totalAmount,
    this.notes,
  });

  String get statusLabel {
    switch (status) {
      case BookingStatus.pending: return 'Pending';
      case BookingStatus.confirmed: return 'Confirmed';
      case BookingStatus.completed: return 'Completed';
      case BookingStatus.cancelled: return 'Cancelled';
    }
  }
}
