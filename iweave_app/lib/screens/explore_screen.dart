import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'itinerary_builder_screen.dart';
import 'product_catalog_screen.dart';
import 'tour_catalog_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Basey')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _ExploreCard(
            title: 'Banig Products',
            subtitle: 'Browse woven bags, accessories, mats, and home pieces.',
            icon: Icons.shopping_bag_rounded,
            color: AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProductCatalogScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _ExploreCard(
            title: 'Curated Tours',
            subtitle: 'Discover tour packages and Basey destinations.',
            icon: Icons.map_rounded,
            color: AppColors.accent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TourCatalogScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _ExploreCard(
            title: 'Itinerary Builder',
            subtitle: 'Build a mock custom route for your Basey visit.',
            icon: Icons.route_rounded,
            color: AppColors.success,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ItineraryBuilderScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ExploreCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.14),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.mutedText,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}