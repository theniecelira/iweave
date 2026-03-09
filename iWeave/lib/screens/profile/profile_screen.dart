import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/cart_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200, pinned: true,
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 44,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Text(
                              user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'G',
                              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              width: 28, height: 28,
                              decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                              child: const Icon(Icons.edit_rounded, size: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(user?.name ?? 'Guest User',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      Text(user?.email ?? '',
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Quick Stats
                  Row(children: [
                    _StatCard(
                      label: 'Bookings',
                      value: '${context.read<BookingProvider>().bookings.length}',
                      icon: Icons.calendar_today_rounded,
                      onTap: () => Navigator.pushNamed(context, '/bookings'),
                    ),
                    const SizedBox(width: 12),
                    _StatCard(
                      label: 'Cart Items',
                      value: '${context.read<CartProvider>().count}',
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
                  ]),
                  const SizedBox(height: 20),

                  // Menu Sections
                  _MenuSection(
                    title: 'My Account',
                    items: [
                      _MenuItem(Icons.person_outline_rounded, 'Edit Profile', () => _showEditProfile(context)),
                      _MenuItem(Icons.location_on_outlined, 'Saved Addresses', () {}),
                      _MenuItem(Icons.payment_outlined, 'Payment Methods', () {}),
                      _MenuItem(Icons.notifications_outlined, 'Notification Settings', () => Navigator.pushNamed(context, '/notifications')),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _MenuSection(
                    title: 'Shopping',
                    items: [
                      _MenuItem(Icons.shopping_bag_outlined, 'My Orders', () => Navigator.pushNamed(context, '/bookings')),
                      _MenuItem(Icons.favorite_border_rounded, 'Wishlist', () {}),
                      _MenuItem(Icons.rate_review_outlined, 'My Reviews', () {}),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _MenuSection(
                    title: 'About iWeave',
                    items: [
                      _MenuItem(Icons.info_outline_rounded, 'About Us', () => _showAbout(context)),
                      _MenuItem(Icons.policy_outlined, 'Terms of Service', () {}),
                      _MenuItem(Icons.local_shipping_outlined, 'Shipping Policy', () {}),
                      _MenuItem(Icons.help_outline_rounded, 'FAQs', () {}),
                      _MenuItem(Icons.mail_outline_rounded, 'Contact Us', () {}),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Logout
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                      border: Border.all(color: AppColors.error.withOpacity(0.2)),
                    ),
                    child: ListTile(
                      onTap: () => _confirmLogout(context),
                      leading: const Icon(Icons.logout_rounded, color: AppColors.error),
                      title: const Text('Sign Out', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.error),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('iWeave v1.0.0 · Est. 2024',
                    style: TextStyle(fontSize: 11, color: AppColors.textHint)),
                  const Text('Basey, Samar, Philippines',
                    style: TextStyle(fontSize: 11, color: AppColors.textHint)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out of iWeave?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<AuthProvider>().logout();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditProfile(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final nameCtrl = TextEditingController(text: auth.user?.name ?? '');
    final phoneCtrl = TextEditingController(text: auth.user?.phone ?? '');

    showModalBottomSheet(
      context: context, isScrollControlled: true, useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined)),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (auth.user != null) {
                    auth.updateUser(auth.user!.copyWith(name: nameCtrl.text, phone: phoneCtrl.text));
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated!'), backgroundColor: AppColors.success),
                  );
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: AppColors.primary),
                child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.waving_hand_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          const Text('iWeave'),
        ]),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Crafting Unforgettable Experiences, One Tikog at A Time!', style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: AppColors.primary)),
            SizedBox(height: 12),
            Text('iWeave is a digital platform that connects tourists and buyers with the master weavers of Basey, Samar — one of the Philippines\'s most celebrated banig-weaving communities.', style: TextStyle(fontSize: 13, height: 1.6, color: AppColors.textSecondary)),
            SizedBox(height: 12),
            Text('By team Weannov8 · University of the Philippines Tacloban College · Est. 2024', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
          ],
        ),
        actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final VoidCallback onTap;
  const _StatCard({required this.label, required this.value, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
          ),
          child: Column(children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
          ]),
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;
  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textHint, letterSpacing: 0.5)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final isLast = e.key == items.length - 1;
              return Column(
                children: [
                  ListTile(
                    onTap: e.value.onTap,
                    leading: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: AppColors.tagBg, borderRadius: BorderRadius.circular(10)),
                      child: Icon(e.value.icon, color: AppColors.primary, size: 18),
                    ),
                    title: Text(e.value.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 18),
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  ),
                  if (!isLast) const Divider(height: 0, indent: 14, endIndent: 14, color: AppColors.divider),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuItem(this.icon, this.label, this.onTap);
}
