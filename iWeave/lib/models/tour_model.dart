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
  final String amenities;
  final int beds;
  final bool freeWifi;
  bool isFavorite;

  AccommodationModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.pricePerNight,
    required this.imageUrl,
    required this.rating,
    required this.amenities,
    required this.beds,
    this.freeWifi = true,
    this.isFavorite = false,
  });
}

class RestaurantModel {
  final String id;
  final String name;
  final String type;
  final String description;
  final String imageUrl;
  final double rating;
  final String hours;
  final bool isOpen;
  bool isFavorite;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.hours,
    this.isOpen = true,
    this.isFavorite = false,
  });
}
