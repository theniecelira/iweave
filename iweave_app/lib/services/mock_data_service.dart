import '../models/app_notification.dart';
import '../models/experience.dart';
import '../models/product.dart';
import '../models/tour_package.dart';
import '../models/weaver.dart';

class MockDataService {
  static const categories = [
    'All',
    'Bags',
    'Home',
    'Accessories',
    'Slippers',
    'Custom',
  ];

  static const productFilters = [
    'Color',
    'Design',
    'Pattern',
    'Size',
  ];

  static const List<Product> products = [
    Product(
      id: 'p1',
      name: 'Tikog Tote Bag',
      category: 'Bags',
      price: 2499,
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
      description:
          'A handcrafted tote inspired by Basey weaving patterns, designed for everyday use with a bold woven finish.',
      palettes: ['Wine', 'Sand', 'Olive'],
      customizable: true,
      featured: true,
    ),
    Product(
      id: 'p2',
      name: 'Banig Laptop Sleeve',
      category: 'Accessories',
      price: 1499,
      imageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3',
      description:
          'A soft protective sleeve with woven texture details, ideal for a modern cultural-inspired look.',
      palettes: ['Rose', 'Gold', 'Forest'],
      customizable: true,
      featured: true,
    ),
    Product(
      id: 'p3',
      name: 'Woven Slippers',
      category: 'Slippers',
      price: 899,
      imageUrl: 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77',
      description:
          'Casual indoor slippers finished with handwoven banig-inspired accents.',
      palettes: ['Coral', 'Cream', 'Maroon'],
      customizable: false,
      featured: false,
    ),
    Product(
      id: 'p4',
      name: 'Banig Table Runner',
      category: 'Home',
      price: 1299,
      imageUrl: 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85',
      description:
          'A decorative dining accent that brings local craft tradition into the home.',
      palettes: ['Amber', 'Plum', 'Moss'],
      customizable: true,
      featured: false,
    ),
    Product(
      id: 'p5',
      name: 'Round Banig Mat',
      category: 'Home',
      price: 1899,
      imageUrl: 'https://images.unsplash.com/photo-1517705008128-361805f42e86',
      description:
          'A colorful statement mat made for relaxing spaces and cozy corners.',
      palettes: ['Sunset', 'Leaf', 'Berry'],
      customizable: true,
      featured: true,
    ),
  ];

  static const List<Experience> experiences = [
    Experience(
      id: 'e1',
      title: 'Hands-on Banig Weaving Experience',
      shortDescription:
          'Immerse yourself in Basey’s weaving culture and create a small woven keepsake.',
      imageUrl: 'https://images.unsplash.com/photo-1517457373958-b7bdd4587205',
      duration: '3 hours',
      price: 299,
      inclusions: [
        'Intro to tikog weaving',
        'Guided weaving session',
        'Take-home souvenir',
      ],
    ),
    Experience(
      id: 'e2',
      title: 'Cultural Immersion Session',
      shortDescription:
          'Meet local artisans and understand the history and livelihood behind the craft.',
      imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
      duration: '2 hours',
      price: 299,
      inclusions: [
        'Community orientation',
        'Weaver story session',
        'Product showcase',
      ],
    ),
  ];

  static const List<TourPackage> tours = [
    TourPackage(
      id: 't1',
      title: 'Basey Culture Trail',
      location: 'Basey, Samar',
      duration: '5 hours',
      rating: 4.9,
      price: 790,
      imageUrl: 'https://images.unsplash.com/photo-1527631746610-bca00a040d60',
      description:
          'A guided cultural route across weaving spaces, food stops, and scenic community locations in Basey.',
      highlights: [
        'Community guide',
        'Photo stops',
        'Local snack stop',
      ],
    ),
    TourPackage(
      id: 't2',
      title: 'Basey Cave + Weaving Tour',
      location: 'Basey, Samar',
      duration: 'Day tour',
      rating: 4.8,
      price: 950,
      imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
      description:
          'A mixed nature-and-culture experience that combines local attractions with artisan visits.',
      highlights: [
        'Cave stop',
        'Workshop visit',
        'Lunch suggestion',
      ],
    ),
    TourPackage(
      id: 't3',
      title: 'Local Heritage Discovery',
      location: 'Basey, Samar',
      duration: '4 hours',
      rating: 4.7,
      price: 650,
      imageUrl: 'https://images.unsplash.com/photo-1467269204594-9661b134dd2b',
      description:
          'A lighter discovery route for travelers who want stories, visuals, and easy access to Basey culture.',
      highlights: [
        'Short guided route',
        'Craft stop',
        'Flexible pacing',
      ],
    ),
  ];

  static const List<Weaver> weavers = [
    Weaver(
      id: 'w1',
      name: 'Jocelyn A.',
      location: 'Basiao, Basey',
      bio:
          'A skilled local weaver passionate about preserving tikog traditions through teaching and handcrafted work.',
      imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
    ),
    Weaver(
      id: 'w2',
      name: 'Marites P.',
      location: 'Basey Proper',
      bio:
          'Focuses on detailed weaving patterns and shares stories about the local craft economy.',
      imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80',
    ),
  ];

  static const List<AppNotification> notifications = [
    AppNotification(
      id: 'n1',
      title: 'Booking confirmed',
      message:
          'Your Hands-on Banig Weaving Experience has been reserved for Saturday.',
      time: '2h ago',
      unread: true,
    ),
    AppNotification(
      id: 'n2',
      title: 'Design saved',
      message: 'Your custom tote concept is now saved in Design Studio.',
      time: 'Yesterday',
      unread: false,
    ),
    AppNotification(
      id: 'n3',
      title: 'New collection',
      message:
          'Fresh woven bags and home pieces are now featured in Explore.',
      time: '2 days ago',
      unread: false,
    ),
  ];
}