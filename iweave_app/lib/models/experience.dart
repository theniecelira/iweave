class Experience {
  final String id;
  final String title;
  final String shortDescription;
  final String imageUrl;
  final String duration;
  final double price;
  final List<String> inclusions;

  const Experience({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.imageUrl,
    required this.duration,
    required this.price,
    required this.inclusions,
  });
}