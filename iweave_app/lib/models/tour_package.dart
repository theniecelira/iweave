class TourPackage {
  final String id;
  final String title;
  final String location;
  final String duration;
  final double rating;
  final double price;
  final String imageUrl;
  final String description;
  final List<String> highlights;

  const TourPackage({
    required this.id,
    required this.title,
    required this.location,
    required this.duration,
    required this.rating,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.highlights,
  });
}