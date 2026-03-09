import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/tour_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/home/section_header.dart';
import '../../widgets/cards/product_card.dart';
import '../../widgets/cards/tour_card.dart';
import '../../data/mock_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final products = context.watch<ProductProvider>();
    final tours = context.watch<TourProvider>();
    final notifs = context.watch<NotificationProvider>();
    final firstName = auth.user?.name.split(' ').first ?? 'Traveler';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 0, pinned: true, floating: true,
            backgroundColor: AppColors.primary,
            title: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('iWeave', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, fontFamily: 'Poppins')),
                    Text('Hello, $firstName 👋',
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, fontFamily: 'Poppins')),
                  ],
                ),
              ],
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/notifications'),
                    icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                  ),
                  if (notifs.unreadCount > 0)
                    Positioned(
                      right: 8, top: 8,
                      child: Container(
                        width: 18, height: 18,
                        decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                        child: Center(
                          child: Text('${notifs.unreadCount}',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/cart'),
                icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
              ),
              const SizedBox(width: 4),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/products'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
                          SizedBox(width: 10),
                          Text('Search products, tours, more...', style: TextStyle(color: AppColors.textHint, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),

                // Banner Carousel
                const SizedBox(height: 16),
                _BannerCarousel(),

                // Category Chips
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SectionHeader(title: 'Our Customized Collections', actionLabel: 'See All', onAction: () => Navigator.pushNamed(context, '/products')),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: ProductProvider.categories.skip(1).map((cat) =>
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _CategoryChip(
                          label: cat,
                          icon: _catIcon(cat),
                          onTap: () => Navigator.pushNamed(context, '/products', arguments: cat),
                        ),
                      )
                    ).toList(),
                  ),
                ),

                // This Week's Highlights (circular products)
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SectionHeader(title: "This Week's Highlight!", actionLabel: 'See All', onAction: () => Navigator.pushNamed(context, '/products')),
                ),
                const SizedBox(height: 12),
                if (products.isLoading)
                  const Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator(color: AppColors.primary)))
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: products.featuredProducts.take(4).map((p) =>
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: SizedBox(
                            width: 100,
                            child: ProductCard(
                              product: p, isCircular: true,
                              onTap: () => Navigator.pushNamed(context, '/product-detail', arguments: p.id),
                            ),
                          ),
                        )
                      ).toList(),
                    ),
                  ),

                // Cultural Immersion Banner
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _CulturalBanner(
                    onTap: () => Navigator.pushNamed(context, '/tours'),
                  ),
                ),

                // Tour Packages
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SectionHeader(title: 'Explore More in Basey', actionLabel: 'See All', onAction: () => Navigator.pushNamed(context, '/tours')),
                ),
                const SizedBox(height: 12),
                if (tours.isLoading)
                  const Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator(color: AppColors.primary)))
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: tours.tours.take(3).map((t) =>
                        Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: SizedBox(
                            width: 220,
                            child: TourCard(
                              tour: t,
                              onTap: () => Navigator.pushNamed(context, '/tour-detail', arguments: t.id),
                            ),
                          ),
                        )
                      ).toList(),
                    ),
                  ),

                // New Collections Banner
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SectionHeader(title: 'New Collections!', actionLabel: 'Shop Now', onAction: () => Navigator.pushNamed(context, '/products')),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _NewCollectionsBanner(onTap: () => Navigator.pushNamed(context, '/products')),
                ),

                // iWeave Stories
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SectionHeader(title: 'iWeave Stories', actionLabel: 'Read More', onAction: () => Navigator.pushNamed(context, '/weavers')),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: mockWeavers.map((w) =>
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _WeaverStoryChip(weaver: w, onTap: () => Navigator.pushNamed(context, '/weavers')),
                      )
                    ).toList(),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _catIcon(String cat) {
    switch (cat) {
      case 'Bags': return Icons.shopping_bag_rounded;
      case 'Mats': return Icons.crop_square_rounded;
      case 'Cases': return Icons.laptop_rounded;
      case 'Wallets': return Icons.account_balance_wallet_rounded;
      case 'Slippers': return Icons.hail_rounded;
      default: return Icons.category_rounded;
    }
  }
}

class _BannerCarousel extends StatefulWidget {
  @override
  State<_BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<_BannerCarousel> {
  int _current = 0;
  final _controller = PageController();

  final _banners = [
    {'title': 'Basey, Samar', 'subtitle': 'iWeave Collection', 'color': AppColors.primary},
    {'title': 'Woven. Experiences.\nConnections.', 'subtitle': 'Customize your banig product', 'color': Color(0xFF5D1030)},
    {'title': 'Book Your Tour', 'subtitle': 'Explore Basey\'s hidden gems', 'color': Color(0xFF3D4A1A)},
  ];

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: _banners.length,
            itemBuilder: (_, i) {
              final b = _banners[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [b['color'] as Color, (b['color'] as Color).withRed(((b['color'] as Color).red + 30).clamp(0, 255))],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (b['subtitle'] != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(b['subtitle'] as String, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                          ),
                        const SizedBox(height: 8),
                        Text(b['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, height: 1.2)),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                        ),
                        child: const Text('Explore', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == _current ? 16 : 6, height: 6,
            decoration: BoxDecoration(
              color: i == _current ? AppColors.primary : AppColors.border,
              borderRadius: BorderRadius.circular(3),
            ),
          )),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _CategoryChip({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 26, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}

class _CulturalBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _CulturalBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          image: const DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1583394293214-0b7f63f85e78?w=600'),
            fit: BoxFit.cover, opacity: 0.4,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Banig Weaving Experience', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text('Immerse in Basey\'s centuries-old tradition', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
              ),
              child: const Text('Book Your Weaving Tour', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewCollectionsBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _NewCollectionsBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          image: const DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?w=600'),
            fit: BoxFit.cover, opacity: 0.3,
          ),
        ),
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Customized Products', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                  Text('Weave your story, Craft your style!', style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
              ),
              child: const Text('Shop Now', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeaverStoryChip extends StatelessWidget {
  final dynamic weaver;
  final VoidCallback onTap;
  const _WeaverStoryChip({required this.weaver, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(weaver.imageUrl),
              backgroundColor: AppColors.tagBg,
            ),
            const SizedBox(height: 8),
            Text(weaver.name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(weaver.specialty, style: const TextStyle(fontSize: 10, color: AppColors.textHint), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
