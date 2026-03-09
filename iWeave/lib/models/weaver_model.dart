class WeaverModel {
  final String id;
  final String name;
  final String bio;
  final String specialty;
  final String imageUrl;
  final int yearsOfExperience;
  final List<String> productIds;
  final double rating;
  final int reviewCount;
  final String location;

  const WeaverModel({
    required this.id,
    required this.name,
    required this.bio,
    required this.specialty,
    required this.imageUrl,
    required this.yearsOfExperience,
    required this.productIds,
    required this.rating,
    required this.reviewCount,
    required this.location,
  });
}
