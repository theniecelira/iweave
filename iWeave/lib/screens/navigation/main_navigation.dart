import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../providers/notification_provider.dart';
import '../home/home_screen.dart';
import '../tours/book_tour_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;
  const MainNavigation({super.key, this.initialIndex = 0});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final _screens = const [
    HomeScreen(),
    BookTourScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final unread = context.watch<NotificationProvider>().unreadCount;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: const Color(0xFF6A0028),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: Offset(0, -4))],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                _NavItem(0, Icons.home_rounded, Icons.home_outlined, 'Home', _currentIndex, _onTap),
                _NavItem(1, Icons.explore_rounded, Icons.explore_outlined, 'Book Tour', _currentIndex, _onTap),
                _NavItem(2, Icons.notifications_rounded, Icons.notifications_outlined, 'Notifications', _currentIndex, _onTap, badge: unread),
                _NavItem(3, Icons.person_rounded, Icons.person_outlined, 'Profile', _currentIndex, _onTap),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int index) => setState(() => _currentIndex = index);
}

class _NavItem extends StatelessWidget {
  final int index, currentIndex;
  final IconData activeIcon, inactiveIcon;
  final String label;
  final Function(int) onTap;
  final int badge;

  const _NavItem(this.index, this.activeIcon, this.inactiveIcon, this.label, this.currentIndex, this.onTap, {this.badge = 0});

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      isActive ? activeIcon : inactiveIcon,
                      color: isActive ? AppColors.mainNavigationSelected : Colors.white,
                      size: 24,
                    ),
                  ),
                  if (badge > 0)
                    Positioned(
                      top: -2, right: 0,
                      child: Container(
                        width: 18, height: 18,
                        decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                        child: Center(
                          child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10, fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                  color: AppColors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
