import '../models/product_model.dart';
import '../models/tour_model.dart';
import '../models/weaver_model.dart';
import '../models/booking_model.dart';
import '../models/notification_model.dart';

// ─── WEAVERS ────────────────────────────────────────────────────────────────
final List<WeaverModel> mockWeavers = [
  WeaverModel(
    id: 'w1', name: 'Nanay Rosario dela Cruz',
    bio: 'With over 35 years of weaving tikog grass into beautiful banig products, Nanay Rosario is one of Basey\'s most celebrated master weavers. Her intricate geometric patterns are recognized throughout Region 8.',
    specialty: 'Geometric Patterns & Mats',
    imageUrl: 'https://images.unsplash.com/photo-1583394293214-0b7f63f85e78?w=400',
    yearsOfExperience: 35,
    productIds: ['p1', 'p3', 'p5'],
    rating: 4.9, reviewCount: 214, location: 'Basey, Samar',
  ),
  WeaverModel(
    id: 'w2', name: 'Aling Perla Santos',
    bio: 'Perla has been weaving since she was 12 years old, learning from her grandmother. She specializes in colorful, modern-inspired designs that blend tradition with contemporary style.',
    specialty: 'Colorful Bags & Accessories',
    imageUrl: 'https://images.unsplash.com/photo-1594736797933-d0401ba2fe65?w=400',
    yearsOfExperience: 28, productIds: ['p2', 'p4'],
    rating: 4.8, reviewCount: 189, location: 'Basey, Samar',
  ),
  WeaverModel(
    id: 'w3', name: 'Manang Luz Reyes',
    bio: 'Luz is known for her exceptional craftsmanship in weaving laptop and tablet cases that perfectly protect devices while showcasing Basey\'s weaving heritage.',
    specialty: 'Tech Accessories & Cases',
    imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400',
    yearsOfExperience: 20, productIds: ['p6', 'p7'],
    rating: 4.7, reviewCount: 156, location: 'Basey, Samar',
  ),
];

// ─── PRODUCTS ───────────────────────────────────────────────────────────────
final List<ProductModel> mockProducts = [
  ProductModel(
    id: 'p1', name: 'Dorothea Tote Bag', category: 'Bags',
    description: 'A beautifully handwoven tote bag made from premium tikog grass. Features the traditional Basey geometric pattern with a durable leather handle. Perfect for beach trips, market runs, or everyday use.',
    basePrice: 2499.0,
    imageUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400',
    additionalImages: [
      'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400',
      'https://images.unsplash.com/photo-1491637639811-60e2756cc1c7?w=400',
    ],
    availableMaterials: ['Tikog', 'Buri'],
    availableColors: ['Natural', 'Red', 'Green', 'Teal', 'Purple'],
    availableDesigns: ['Traditional Geometric', 'Chevron', 'Diamond'],
    rating: 4.8, reviewCount: 918,
    weaverId: 'w1', weaverName: 'Nanay Rosario dela Cruz',
    isFeatured: true,
  ),
  ProductModel(
    id: 'p2', name: 'Aimee Sling Bag', category: 'Bags',
    description: 'Compact and stylish, this sling bag is perfect for day trips around Basey. Hand-crafted with intricate patterns that represent the cultural identity of Eastern Visayas.',
    basePrice: 1049.0,
    imageUrl: 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=400',
    rating: 4.6, reviewCount: 412,
    weaverId: 'w2', weaverName: 'Aling Perla Santos',
    isFeatured: true,
  ),
  ProductModel(
    id: 'p3', name: 'Betty Backpack', category: 'Bags',
    description: 'A spacious, lightweight backpack woven from natural tikog fibers. Features internal pockets and adjustable straps. Perfect for school, travel, or daily use.',
    basePrice: 1499.0,
    imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
    rating: 4.7, reviewCount: 287,
    weaverId: 'w1', weaverName: 'Nanay Rosario dela Cruz',
    isFeatured: true,
  ),
  ProductModel(
    id: 'p4', name: 'Classic Banig Mat', category: 'Mats',
    description: 'The classic Basey banig mat — a prized heirloom piece. Each mat takes days to weave and features the signature tikog pattern that has been passed down for generations.',
    basePrice: 1899.0,
    imageUrl: 'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?w=400',
    rating: 4.9, reviewCount: 634,
    weaverId: 'w2', weaverName: 'Aling Perla Santos',
    isFeatured: true,
  ),
  ProductModel(
    id: 'p5', name: 'Banig Placemat Set (4pcs)', category: 'Mats',
    description: 'A set of 4 elegantly woven placemats. Add a touch of Filipino artistry to your dining table. Easy to clean and very durable.',
    basePrice: 799.0,
    imageUrl: 'https://images.unsplash.com/photo-1495195134817-aeb325a55b65?w=400',
    rating: 4.5, reviewCount: 201,
    weaverId: 'w1', weaverName: 'Nanay Rosario dela Cruz',
  ),
  ProductModel(
    id: 'p6', name: 'Tikog Laptop Case 13"', category: 'Cases',
    description: 'Protect your laptop in style with this handwoven banig case. Padded interior for full protection, outer woven shell for unique aesthetics.',
    basePrice: 1299.0,
    imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400',
    rating: 4.7, reviewCount: 189,
    weaverId: 'w3', weaverName: 'Manang Luz Reyes',
  ),
  ProductModel(
    id: 'p7', name: 'Tablet Case Universal', category: 'Cases',
    description: 'Universal tablet case fitting most 7-11" tablets. Handwoven with premium tikog, each case is unique and one-of-a-kind.',
    basePrice: 899.0,
    imageUrl: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400',
    rating: 4.6, reviewCount: 143,
    weaverId: 'w3', weaverName: 'Manang Luz Reyes',
  ),
  ProductModel(
    id: 'p8', name: 'Woven Bifold Wallet', category: 'Wallets',
    description: 'A slim, functional wallet handwoven from tikog fibers with genuine leather interior. Multiple card slots and a bill compartment.',
    basePrice: 599.0,
    imageUrl: 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=400',
    rating: 4.4, reviewCount: 298,
    weaverId: 'w2', weaverName: 'Aling Perla Santos',
  ),
  ProductModel(
    id: 'p9', name: 'Banig Slippers (Pair)', category: 'Slippers',
    description: 'Comfortable and stylish slippers woven from natural tikog grass. Available in sizes S to XL. Non-slip sole for safe indoor use.',
    basePrice: 449.0,
    imageUrl: 'https://images.unsplash.com/photo-1519241047957-be31d7379a5d?w=400',
    rating: 4.3, reviewCount: 456,
    weaverId: 'w1', weaverName: 'Nanay Rosario dela Cruz',
  ),
  ProductModel(
    id: 'p10', name: 'Zip Pouch / Clutch', category: 'Wallets',
    description: 'Versatile zip pouch that doubles as a clutch or cosmetics bag. Handwoven banig exterior with a zipper closure and fabric lining.',
    basePrice: 499.0,
    imageUrl: 'https://images.unsplash.com/photo-1598532163257-ae3c6b2524b6?w=400',
    rating: 4.6, reviewCount: 178,
    weaverId: 'w2', weaverName: 'Aling Perla Santos',
  ),
];

// ─── TOURS ──────────────────────────────────────────────────────────────────
final List<TourModel> mockTours = [
  TourModel(
    id: 't1',
    title: '3-Day Saob Cave Tour with Hands-on Weaving Experience',
    description: 'Take a break from the hustle and bustle and immerse yourself in the serene and culturally rich environment of Basey. This exclusive tour offers a unique combination of natural beauty and hands-on cultural experience. You\'ll explore the enchanting Saob Cave and participate in a traditional banig weaving workshop, guided by local artisans. Your package includes expert guides, all necessary weaving materials, and round-trip private transfers from your accommodation.',
    highlights: [
      'Discover the stunning underground formations of Saob Cave',
      'Learn the traditional craft from skilled local weavers, creating your own unique piece to take home as a souvenir',
      'Connect with the artisans, learn about their techniques, and appreciate the rich history behind banig weaving',
      'Enjoy stress-free round-trip private transfers from your hotel in Basey, ensuring a comfortable and hassle-free journey',
    ],
    price: 599.0, originalPrice: 720.0,
    imageUrl: 'https://images.unsplash.com/photo-1520769669658-f07657f5a307?w=400',
    additionalImages: [
      'https://images.unsplash.com/photo-1562016600-ece13e8ba570?w=400',
      'https://images.unsplash.com/photo-1583394293214-0b7f63f85e78?w=400',
    ],
    category: TourCategory.cave,
    durationDays: 3, rating: 8.0, reviewCount: 918,
    operator: 'Basey Tours', isTouristFavorite: true,
  ),
  TourModel(
    id: 't2',
    title: '5-Day Sohoton Cave & Natural Bridge Park Adventure Package',
    description: 'Explore the breathtaking Sohoton Natural Bridge and Cave System, one of the Philippines\' most spectacular natural wonders. Combined with cultural immersion activities in Basey, this adventure package offers the perfect blend of nature and heritage.',
    highlights: [
      'Boat tour through Sohoton Cove',
      'Visit the Natural Bridge formation',
      'Hands-on banig weaving session',
      'Local seafood feast',
    ],
    price: 899.0, originalPrice: 0,
    imageUrl: 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=400',
    category: TourCategory.cave,
    durationDays: 5, rating: 7.2, reviewCount: 728,
    operator: 'Eastern Visayas Tours',
  ),
  TourModel(
    id: 't3',
    title: '1-Day St. Michael the Archangel Parish Church Tour',
    description: 'Discover the historic St. Michael the Archangel Parish Church, a testament to Basey\'s rich colonial history. This guided day tour includes a visit to the church, the town plaza, and local artisan workshops.',
    highlights: [
      'Guided tour of the 18th-century church',
      'Visit local artisan workshops',
      'Sample local delicacies',
      'Town plaza cultural walk',
    ],
    price: 799.0, originalPrice: 900.0,
    imageUrl: 'https://images.unsplash.com/photo-1548625149-720134d33b04?w=400',
    category: TourCategory.church,
    durationDays: 1, rating: 5.9, reviewCount: 852,
    operator: 'Heritage Basey',
  ),
  TourModel(
    id: 't4',
    title: 'Weekend Escape: 2-Day Basey Exploration Package',
    description: 'The perfect weekend getaway from the city! This 2-day package combines the best of Basey — natural wonders, cultural heritage, and authentic local experiences.',
    highlights: [
      'Cave exploration',
      'Cultural immersion with weavers',
      'Local seafood dinner',
      'Sunrise river cruise',
    ],
    price: 499.0, originalPrice: 650.0,
    imageUrl: 'https://images.unsplash.com/photo-1506197603052-3cc9c3a201bd?w=400',
    category: TourCategory.weaving,
    durationDays: 2, rating: 4.8, reviewCount: 504,
    operator: 'Basey Adventure Co.',
  ),
  TourModel(
    id: 't5',
    title: 'Customize Your Own Basey Tour',
    description: 'Create your perfect Basey experience! Select the attractions, activities, and duration that match your interests and schedule. Our local guides will craft a personalized itinerary just for you.',
    highlights: [
      'Choose your own attractions',
      'Flexible dates and duration',
      'Personal guide included',
      'All logistics handled',
    ],
    price: 350.0,
    imageUrl: 'https://images.unsplash.com/photo-1527631746610-bca00a040d60?w=400',
    category: TourCategory.all,
    durationDays: 1, rating: 9.0, reviewCount: 123,
    operator: 'iWeave Custom Tours',
    isTouristFavorite: true,
  ),
];

// ─── ACCOMMODATIONS ─────────────────────────────────────────────────────────
final List<AccommodationModel> mockAccommodations = [
  AccommodationModel(
    id: 'a1', name: 'Bed and Breakfast in Basey',
    type: 'Bed and Breakfast',
    description: 'Cozy couple room with pool and beach access. Wake up to stunning views of the bay.',
    pricePerNight: 2567.0,
    imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
    rating: 4.0, amenities: 'Pool, Beach Access, Free Wifi', beds: 1,
  ),
  AccommodationModel(
    id: 'a2', name: 'Clean and Comfortable 1-Bedroom w/ Rooftop',
    type: 'Guesthouse',
    description: 'Modern guesthouse with a stunning rooftop terrace overlooking Basey. Perfect for travelers seeking comfort and panoramic views.',
    pricePerNight: 2496.0,
    imageUrl: 'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=400',
    rating: 5.0, amenities: 'Rooftop, Free Wifi', beds: 1,
  ),
  AccommodationModel(
    id: 'a3', name: 'Home in Marabut',
    type: 'Private Resort',
    description: 'Spacious private resort near the scenic Marabut islands. Ideal for families and groups seeking a peaceful retreat.',
    pricePerNight: 5741.0,
    imageUrl: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400',
    rating: 4.5, amenities: 'Private Pool, Beach, Free Wifi', beds: 6,
  ),
  AccommodationModel(
    id: 'a4', name: 'Guesthouse in Maydolong',
    type: 'Surf Front Villa',
    description: 'A charming surf-front villa in Maydolong with breathtaking ocean views. Perfect for surf enthusiasts and beach lovers.',
    pricePerNight: 2168.0,
    imageUrl: 'https://images.unsplash.com/photo-1586375300773-8384e3e4916f?w=400',
    rating: 4.5, amenities: 'Surf Access, Free Wifi', beds: 2,
  ),
];

// ─── RESTAURANTS ────────────────────────────────────────────────────────────
final List<RestaurantModel> mockRestaurants = [
  RestaurantModel(
    id: 'r1', name: 'Tasteful Table by Chef J',
    type: 'Fast Food', description: 'Local comfort food with a modern twist. Famous for their fresh seafood dishes and banig-inspired presentation.',
    imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400',
    rating: 3.8, hours: 'Open | Closes 7 PM',
  ),
  RestaurantModel(
    id: 'r2', name: 'The Yum Yard',
    type: 'Restaurant', description: 'A family restaurant serving authentic Waray-Waray cuisine. Must-try: their kinilaw and freshly grilled fish.',
    imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400',
    rating: 5.0, hours: 'Open | Closes 7 PM',
  ),
  RestaurantModel(
    id: 'r3', name: 'Karl\'s Cà Phê',
    type: 'Cafe', description: 'Cozy cafe with specialty brews and artisanal snacks. The perfect spot to rest after exploring Basey\'s attractions.',
    imageUrl: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=400',
    rating: 4.5, hours: 'Open | Closes 9 PM',
  ),
  RestaurantModel(
    id: 'r4', name: 'Balay ni Romana',
    type: 'Cafe', description: 'A heritage house transformed into a charming dining venue. Known for their traditional Filipino breakfast and merienda.',
    imageUrl: 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=400',
    rating: 4.5, hours: 'Open | Closes 8 PM',
  ),
];

// ─── BOOKINGS ────────────────────────────────────────────────────────────────
List<BookingModel> mockBookings = [
  BookingModel(
    id: 'b1', userId: 'u1',
    itemId: 't1', itemName: '3-Day Saob Cave Tour',
    itemImage: 'https://images.unsplash.com/photo-1520769669658-f07657f5a307?w=400',
    type: BookingType.tour, status: BookingStatus.confirmed,
    bookingDate: DateTime.now().subtract(const Duration(days: 2)),
    checkIn: DateTime.now().add(const Duration(days: 5)),
    checkOut: DateTime.now().add(const Duration(days: 8)),
    guests: 2, totalAmount: 1198.0,
  ),
  BookingModel(
    id: 'b2', userId: 'u1',
    itemId: 'a2', itemName: 'Clean and Comfortable 1-Bedroom w/ Rooftop',
    itemImage: 'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=400',
    type: BookingType.accommodation, status: BookingStatus.pending,
    bookingDate: DateTime.now().subtract(const Duration(hours: 3)),
    checkIn: DateTime.now().add(const Duration(days: 5)),
    checkOut: DateTime.now().add(const Duration(days: 7)),
    guests: 2, totalAmount: 4992.0,
  ),
];

// ─── NOTIFICATIONS ───────────────────────────────────────────────────────────
List<NotificationModel> mockNotifications = [
  NotificationModel(
    id: 'n1', title: 'Booking Confirmed!',
    message: 'Your 3-Day Saob Cave Tour has been confirmed. Get ready for an amazing experience!',
    type: NotificationType.tour,
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  NotificationModel(
    id: 'n2', title: 'Your order is being prepared',
    message: 'Nanay Rosario has started weaving your Dorothea Tote Bag. Estimated completion: 7-10 days.',
    type: NotificationType.order,
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  NotificationModel(
    id: 'n3', title: '🎉 Special Offer!',
    message: 'Get 20% off all customized products this week! Use code WEAVE20 at checkout.',
    type: NotificationType.promo,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    isRead: true,
  ),
  NotificationModel(
    id: 'n4', title: 'New Weaver Story Added',
    message: 'Read the inspiring story of Manang Luz and how she turned weaving into her life\'s work.',
    type: NotificationType.system,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    isRead: true,
  ),
];
