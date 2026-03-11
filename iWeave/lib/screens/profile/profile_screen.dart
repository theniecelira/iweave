import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/user_model.dart';
import 'profile-edit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().user?.id ?? '';
      if (userId.isNotEmpty) {
        context.read<BookingProvider>().loadBookings(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth     = context.watch<AuthProvider>();
    final bookings = context.watch<BookingProvider>();
    final cart     = context.watch<CartProvider>();
    final user     = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar / Hero Header ─────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),

                      // Avatar + orange edit pen
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 44,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Text(
                              user?.name.isNotEmpty == true
                                  ? user!.name[0].toUpperCase()
                                  : 'G',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // ✅ FIX: orange pen now navigates to EditProfileScreen
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EditProfileScreen(),
                                ),
                              ),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: const BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      Text(
                        user?.name ?? 'Guest User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        user?.email ?? '',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Body ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  // ── Quick Stats ──────────────────────────────────────
                  Row(
                    children: [
                      // ✅ FIX: onTap now uses the passed-in callback
                      _StatCard(
                        label: 'Bookings',
                        value: '${bookings.bookings.length}',
                        icon: Icons.calendar_today_rounded,
                        onTap: () => Navigator.pushNamed(context, '/bookings'),
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        label: 'Cart Items',
                        value: '${cart.count}',
                        icon: Icons.shopping_bag_rounded,
                        onTap: () => Navigator.pushNamed(context, '/cart'),
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        label: 'Reviews',
                        value: '5',
                        icon: Icons.star_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── My Account ───────────────────────────────────────
                  _MenuSection(
                    title: 'My Account',
                    items: [
                      // ✅ Edit Profile → navigates to EditProfileScreen
                      _MenuItem(
                        Icons.person_outline_rounded,
                        'Edit Profile',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        ),
                      ),
                      _MenuItem(Icons.location_on_outlined,    'Saved Addresses',        () {}),
                      _MenuItem(Icons.payment_outlined,         'Payment Methods',        () {}),
                      _MenuItem(
                        Icons.notifications_outlined,
                        'Notification Settings',
                        () => Navigator.pushNamed(context, '/notifications'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ── Shopping ─────────────────────────────────────────
                  _MenuSection(
                    title: 'Shopping',
                    items: [
                      _MenuItem(
                        Icons.shopping_bag_outlined,
                        'My Orders',
                        () => Navigator.pushNamed(context, '/bookings'),
                      ),
                      _MenuItem(Icons.favorite_border_rounded, 'Wishlist',    () {}),
                      _MenuItem(Icons.rate_review_outlined,    'My Reviews',  () {}),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ── About iWeave ─────────────────────────────────────
                  _MenuSection(
                    title: 'About iWeave',
                    items: [
                      _MenuItem(Icons.info_outline_rounded,    'About Us',       () {}),
                      _MenuItem(Icons.help_outline_rounded,    'Help & Support', () {}),
                      _MenuItem(Icons.privacy_tip_outlined,    'Privacy Policy', () {}),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Log Out ──────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await auth.logout();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (route) => false,
                          );
                        }
                      },
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: const Text('Log Out'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stat Card ─────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        // ✅ FIX: uses the passed-in onTap instead of hardcoded navigation
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 22, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Menu Section ──────────────────────────────────────────────────────────
class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;
  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textHint,
              ),
            ),
          ),

          // ✅ FIX: each item uses its own icon, label, and onTap
          ...items.map(
            (item) => ListTile(
              onTap: item.onTap,
              leading: Icon(item.icon, color: AppColors.primary, size: 22),
              title: Text(
                item.label,
                style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.textHint,
              ),
            ),
          ),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ─── Menu Item model ───────────────────────────────────────────────────────
class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuItem(this.icon, this.label, this.onTap);
}