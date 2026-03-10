enum TourCategory { all, cave, bridge, church, weaving }

class TourModel {
  final String id;
  final String title;
  final String description;
  final List<String> highlights;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final List<String> additionalImages;
  final TourCategory category;
  final int durationDays;
  final String startTime;
  final List<String> languages;
  final bool pickupOffered;
  final double rating;
  final int reviewCount;
  final String operator;
  final bool isTouristFavorite;
  bool isFavorite;

  TourModel({
    required this.id,
    required this.title,
    required this.description,
    required this.highlights,
    required this.price,
    this.originalPrice = 0,
    required this.imageUrl,
    this.additionalImages = const [],
    required this.category,
    required this.durationDays,
    this.startTime = 'At 9:00 AM',
    this.languages = const ['English', 'Filipino', 'Waray'],
    this.pickupOffered = true,
    required this.rating,
    required this.reviewCount,
    required this.operator,
    this.isTouristFavorite = false,
    this.isFavorite = false,
  });
}

class AccommodationModel {
  final String id;
  final String name;
  final String type;
  final String description;
  final double pricePerNight;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final List<String> amenities;
  final String location;

  AccommodationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.pricePerNight,
    required this.rating,
    required this.reviewCount,
    required this.amenities,
    required this.type,
  });
}

class RestaurantModel {
  final String id;
  final String name;
  final String cuisine;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String priceRange;
  final String location;
  final String openHours;
  final bool isHalal;
  final int averageMealCost;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.cuisine,
    required this.priceRange,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.openHours,
    required this.isHalal,
    required this.averageMealCost,
  });
}