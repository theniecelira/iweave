enum OrderStatus { pending, processing, shipped, delivered, cancelled }

class OrderItemModel {
  final String productId;
  final String productName;
  final String productImage;
  final String weaverName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? selectedMaterial;
  final String? selectedColor;
  final String? selectedDesign;
  final bool giftWrap;
  final String? giftMessage;
  final String? giftFrom;
  final String? giftTo;

  const OrderItemModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.weaverName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.selectedMaterial,
    this.selectedColor,
    this.selectedDesign,
    this.giftWrap = false,
    this.giftMessage,
    this.giftFrom,
    this.giftTo,
  });
}

class OrderModel {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final OrderStatus status;
  final DateTime orderDate;
  final List<OrderItemModel> items;
  final double subtotal;
  final double shippingFee;
  final double totalAmount;
  final String? shippingAddress;
  final String? notes;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.status,
    required this.orderDate,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.totalAmount,
    this.shippingAddress,
    this.notes,
  });

  int get totalItems => items.fold(0, (s, i) => s + i.quantity);

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending: return 'Pending';
      case OrderStatus.processing: return 'Being Woven';
      case OrderStatus.shipped: return 'Shipped';
      case OrderStatus.delivered: return 'Delivered';
      case OrderStatus.cancelled: return 'Cancelled';
    }
  }
}
