class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final String description;
  final List<String> palettes;
  final bool customizable;
  final bool featured;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.palettes,
    required this.customizable,
    required this.featured,
  });
}