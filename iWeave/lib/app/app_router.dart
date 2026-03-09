import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/navigation/main_navigation.dart';
import '../screens/products/products_screen.dart';
import '../screens/products/product_detail_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/tours/book_tour_screen.dart';
import '../screens/tours/tour_detail_screen.dart';
import '../screens/bookings/bookings_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/weavers/weavers_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _fade(const SplashScreen());
      case '/onboarding':
        return _slide(const OnboardingScreen());
      case '/login':
        return _slide(const LoginScreen());
      case '/signup':
        return _slide(const SignupScreen());
      case '/forgot-password':
        return _slide(const ForgotPasswordScreen());
      case '/main':
        final idx = settings.arguments is int ? settings.arguments as int : 0;
        return _fade(MainNavigation(initialIndex: idx));
      case '/products':
        final cat = settings.arguments is String ? settings.arguments as String : null;
        return _slide(ProductsScreen(initialCategory: cat));
      case '/product-detail':
        final id = settings.arguments as String? ?? '';
        return _slide(ProductDetailScreen(productId: id));
      case '/cart':
        return _slide(const CartScreen());
      case '/tours':
        return _slide(const BookTourScreen());
      case '/tour-detail':
        final id = settings.arguments as String? ?? '';
        return _slide(TourDetailScreen(tourId: id));
      case '/bookings':
        return _slide(const BookingsScreen());
      case '/notifications':
        return _slide(const NotificationsScreen());
      case '/weavers':
        return _slide(const WeaversScreen());
      case '/profile':
        return _slide(const ProfileScreen());
      default:
        return _fade(const SplashScreen());
    }
  }

  static PageRoute _fade(Widget page) => PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
    transitionDuration: const Duration(milliseconds: 300),
  );

  static PageRoute _slide(Widget page) => PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, anim, __, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
      return SlideTransition(position: anim.drive(tween), child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
