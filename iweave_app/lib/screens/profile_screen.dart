import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: AppColors.border,
                  child: Icon(Icons.person_rounded,
                      size: 34, color: AppColors.primary),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Euge Traveler',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Cultural explorer • Mock profile',
                        style: TextStyle(color: AppColors.mutedText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const _ProfileItem(
            icon: Icons.calendar_month_rounded,
            title: 'Upcoming bookings',
            subtitle: '1 weaving experience reserved',
          ),
          const _ProfileItem(
            icon: Icons.favorite_border_rounded,
            title: 'Saved products',
            subtitle: '3 items in wishlist',
          ),
          const _ProfileItem(
            icon: Icons.design_services_rounded,
            title: 'Saved designs',
            subtitle: '2 design drafts',
          ),
          const _ProfileItem(
            icon: Icons.menu_book_rounded,
            title: 'Weaver stories',
            subtitle: 'Discover community content',
          ),
          const _ProfileItem(
            icon: Icons.settings_outlined,
            title: 'Preferences',
            subtitle: 'Notifications, language, support',
          ),
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}