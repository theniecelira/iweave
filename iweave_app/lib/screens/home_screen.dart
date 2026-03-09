import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/mock_data_service.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/experience_card.dart';
import '../widgets/product_card.dart';
import '../widgets/section_header.dart';
import '../widgets/weaver_card.dart';
import 'experience_detail_screen.dart';
import 'product_catalog_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final featuredProducts =
        MockDataService.products.where((p) => p.featured).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'iWeave',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          const CustomSearchBar(
            hint: 'Search products, tours, or experiences',
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Woven experiences,\ncrafted for you.',
                  style: TextStyle(
                    fontSize: 28,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Discover cultural immersion, custom woven products, and Basey tourism in one Android-first experience.',
                  style: TextStyle(
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProductCatalogScreen(),
                      ),
                    );
                  },
                  child: const Text('Shop collections'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Featured products',
            actionLabel: 'View all',
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
          SizedBox(
            height: 255,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: featuredProducts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final product = featuredProducts[index];
                return SizedBox(
                  width: 180,
                  child: ProductCard(
                    product: product,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Cultural immersion'),
          const SizedBox(height: 12),
          SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MockDataService.experiences.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final exp = MockDataService.experiences[index];
                return ExperienceCard(
                  experience: exp,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExperienceDetailScreen(exp: exp),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Meet the weavers'),
          const SizedBox(height: 12),
          SizedBox(
            height: 108,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MockDataService.weavers.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return WeaverCard(weaver: MockDataService.weavers[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}