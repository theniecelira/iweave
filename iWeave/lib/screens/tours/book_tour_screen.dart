import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../providers/tour_provider.dart';
import '../../widgets/cards/tour_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../../core/utils/formatters.dart';
import '../../models/tour_model.dart';

class BookTourScreen extends StatelessWidget {
  const BookTourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Unlock Basey\'s Treasures'),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textHint,
            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
            tabs: const [
              Tab(text: 'Tour Packages'),
              Tab(text: 'Hotels & Homes'),
              Tab(text: 'Restaurants'),
              Tab(text: 'Transport'),
              Tab(text: 'Flights'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TourPackagesTab(),
            _HotelsTab(),
            _RestaurantsTab(),
            _ComingSoonTab(label: 'Transport', icon: Icons.directions_bus_rounded),
            _ComingSoonTab(label: 'Flights', icon: Icons.flight_rounded),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final String hint;
  final VoidCallback? onTap;
  const _SearchBar({required this.hint, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Where', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text(hint, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                ],
              ),
            ),
            const VerticalDivider(width: 20, color: AppColors.border),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Date', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  const Text('Add dates', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                ],
              ),
            ),
            const VerticalDivider(width: 20, color: AppColors.border),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Who', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  const Text('Add tourists', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                ],
              ),
            ),
            Container(
              width: 36, height: 36,
              decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
              child: const Icon(Icons.search_rounded, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _TourPackagesTab extends StatelessWidget {
  const _TourPackagesTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TourProvider>();
    final categories = [
      (TourCategory.all, 'All', Icons.grid_view_rounded),
      (TourCategory.cave, 'Cave', Icons.landscape_rounded),
      (TourCategory.bridge, 'Bridge', Icons.account_balance_rounded),
      (TourCategory.church, 'Church', Icons.church_rounded),
      (TourCategory.weaving, 'Weaving', Icons.grid_3x3_rounded),
    ];

    return Column(
      children: [
        const _SearchBar(hint: 'Search Basey\'s Tourist Spots'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: categories.map((cat) {
              final isSelected = provider.selectedCategory == cat.$1;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => provider.setCategory(cat.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                      boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4)],
                    ),
                    child: Row(
                      children: [
                        Icon(cat.$3, size: 14, color: isSelected ? Colors.white : AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(cat.$2, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textSecondary)),
                        if (cat.$1 == TourCategory.all)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(4)),
                            child: const Text('NEW', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: provider.isLoading
            ? const LoadingWidget()
            : provider.tours.isEmpty
              ? const EmptyStateWidget(title: 'No tours found', icon: Icons.explore_off_rounded)
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 12,
                    mainAxisSpacing: 12, childAspectRatio: 0.70,
                  ),
                  itemCount: provider.tours.length,
                  itemBuilder: (_, i) {
                    final t = provider.tours[i];
                    return TourCard(
                      tour: t,
                      onTap: () => Navigator.pushNamed(context, '/tour-detail', arguments: t.id),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _HotelsTab extends StatelessWidget {
  const _HotelsTab();

  @override
  Widget build(BuildContext context) {
    final accommodations = context.watch<TourProvider>().accommodations;
    final types = ['All', 'Hostels', 'Guesthouses', 'Bed and Breakfast'];

    return Column(
      children: [
        const _SearchBar(hint: 'Search Basey\'s Hotels & Homes'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: types.map((t) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
                label: Text(t, style: const TextStyle(fontSize: 12)),
                backgroundColor: t == 'All' ? AppColors.primary : AppColors.tagBg,
                labelStyle: TextStyle(color: t == 'All' ? Colors.white : AppColors.tagText, fontWeight: FontWeight.w600),
                side: BorderSide.none,
              ),
            )).toList(),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 12,
              mainAxisSpacing: 12, childAspectRatio: 0.8,
            ),
            itemCount: accommodations.length,
            itemBuilder: (_, i) => AccommodationCard(
              accommodation: accommodations[i],
              onTap: () => _showAccommodationDetail(context, accommodations[i]),
            ),
          ),
        ),
      ],
    );
  }

  void _showAccommodationDetail(BuildContext context, dynamic acc) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _AccommodationDetailSheet(accommodation: acc),
    );
  }
}

class _AccommodationDetailSheet extends StatelessWidget {
  final dynamic accommodation;
  const _AccommodationDetailSheet({required this.accommodation});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false, initialChildSize: 0.85, maxChildSize: 0.95,
      builder: (_, ctrl) => ListView(
        controller: ctrl,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.network(accommodation.imageUrl, height: 200, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(height: 200, color: AppColors.tagBg)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(accommodation.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.star_rounded, size: 16, color: AppColors.star),
                  const SizedBox(width: 4),
                  Text('${accommodation.rating} · ${accommodation.type}', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                ]),
                const SizedBox(height: 12),
                Text(accommodation.description, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6)),
                const SizedBox(height: 16),
                _ChipRow(items: accommodation.amenities.split(', ')),
                const SizedBox(height: 20),
                Row(children: [
                  Text(AppFormatters.currency(accommodation.pricePerNight),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  const Text(' / night', style: TextStyle(fontSize: 14, color: AppColors.textHint)),
                ]),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _showBookingConfirmation(context),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52), backgroundColor: AppColors.primary),
                  child: const Text('Reserve Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingConfirmation(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.check_circle_rounded, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text('Reservation for ${accommodation.name} confirmed!')),
        ]),
        backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  final List<String> items;
  const _ChipRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: items.map((i) => Chip(
        label: Text(i, style: const TextStyle(fontSize: 12)),
        backgroundColor: AppColors.tagBg,
        labelStyle: const TextStyle(color: AppColors.tagText),
        side: BorderSide.none,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 4),
      )).toList(),
    );
  }
}

class _RestaurantsTab extends StatelessWidget {
  const _RestaurantsTab();

  @override
  Widget build(BuildContext context) {
    final restaurants = context.watch<TourProvider>().restaurants;
    return Column(
      children: [
        const _SearchBar(hint: 'Search Basey\'s Restaurants'),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: restaurants.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final r = restaurants[i];
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
                      child: Image.network(r.imageUrl, width: 110, height: 100, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 110, height: 100, color: AppColors.tagBg)),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Expanded(child: Text(r.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis)),
                              Row(children: List.generate(5, (j) => Icon(Icons.star_rounded, size: 12, color: j < r.rating.floor() ? AppColors.star : AppColors.border))),
                            ]),
                            Text(r.type, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                            const SizedBox(height: 4),
                            Row(children: [
                              Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
                              const SizedBox(width: 4),
                              Text(r.hours, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ]),
                            const SizedBox(height: 8),
                            Row(children: [
                              _SmallBtn(Icons.directions_rounded, 'Directions'),
                              const SizedBox(width: 6),
                              _SmallBtn(Icons.menu_book_rounded, 'Menu'),
                              const SizedBox(width: 6),
                              _SmallBtn(Icons.phone_rounded, 'Call'),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SmallBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SmallBtn(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(border: Border.all(color: AppColors.primary), borderRadius: BorderRadius.circular(6)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: AppColors.primary),
        const SizedBox(width: 3),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _ComingSoonTab extends StatelessWidget {
  final String label;
  final IconData icon;
  const _ComingSoonTab({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(color: AppColors.tagBg, shape: BoxShape.circle),
            child: Icon(icon, size: 56, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text('$label Booking', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('Coming Soon!', style: TextStyle(fontSize: 14, color: AppColors.textHint)),
        ],
      ),
    );
  }
}