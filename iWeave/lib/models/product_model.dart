class ProductModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final double basePrice;
  final String imageUrl;
  final List<String> additionalImages;
  final List<String> availableMaterials;
  final List<String> availableColors;
  final List<String> availableDesigns;
  final bool isCustomizable;
  final double rating;
  final int reviewCount;
  final String weaverId;
  final String weaverName;
  final bool isFeatured;
  bool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.basePrice,
    required this.imageUrl,
    this.additionalImages = const [],
    this.availableMaterials = const ['Tikog', 'Buri', 'Pandan'],
    this.availableColors = const ['Natural', 'Red', 'Green', 'Blue', 'Yellow', 'Purple'],
    this.availableDesigns = const ['Traditional', 'Modern', 'Floral', 'Geometric'],
    this.isCustomizable = true,
    required this.rating,
    required this.reviewCount,
    required this.weaverId,
    required this.weaverName,
    this.isFeatured = false,
    this.isFavorite = false,
  });
}

class CartItem {
  final ProductModel product;
  int quantity;
  String? selectedMaterial;
  String? selectedColor;
  String? selectedDesign;
  bool giftWrap;
  String? giftMessage;
  String? giftFrom;
  String? giftTo;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedMaterial,
    this.selectedColor,
    this.selectedDesign,
    this.giftWrap = false,
    this.giftMessage,
    this.giftFrom,
    this.giftTo,
  });

  double get totalPrice => product.basePrice * quantity + (giftWrap ? 25.0 : 0.0);
}
