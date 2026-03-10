import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/formatters.dart';
import '../../models/itinerary_model.dart';
import '../../models/booking_model.dart';
import '../../providers/itinerary_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/auth_provider.dart';
import '../../data/mock_attractions.dart';
import '../../models/tour_model.dart';
import '../../widgets/common/app_button.dart';

class ItineraryBuilderScreen extends StatelessWidget {
  const ItineraryBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItineraryProvider>();
    final step = provider.currentStep;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(step == 0
            ? 'Plan Your Trip'
            : step == 1
                ? 'Build Itinerary'
                : 'Review Trip'),
        bottom: step > 0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(4),
                child: _StepIndicator(step: step),
              )
            : null,
      ),
      body: switch (step) {
        0 => const _SetupStep(),
        1 => const _BuildStep(),
        _ => const _ReviewStep(),
      },
    );
  }
}

// ─── STEP INDICATOR ──────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final int step;
  const _StepIndicator({required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(2, (i) {
        return Expanded(
          child: Container(
            height: 4,
            color: i < step ? AppColors.primary : AppColors.divider,
            margin: EdgeInsets.only(right: i < 1 ? 2 : 0),
          ),
        );
      }),
    );
  }
}

// ─── STEP 1: SETUP ───────────────────────────────────────────────────────────

class _SetupStep extends StatefulWidget {
  const _SetupStep();
  @override
  State<_SetupStep> createState() => _SetupStepState();
}

class _SetupStepState extends State<_SetupStep> {
  final _nameCtrl = TextEditingController(text: 'My Basey Adventure');
  DateTime _startDate = DateTime.now().add(const Duration(days: 3));
  int _days = 2;
  int _guests = 1;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.map_rounded, color: Colors.white, size: 32),
                const SizedBox(height: 10),
                const Text('Customizable Itinerary Builder',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  'Design your perfect Basey experience — choose attractions, dining, stays & weaving workshops.',
                  style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _Label('Trip Name'),
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              hintText: 'e.g. Basey Family Getaway',
              prefixIcon: const Icon(Icons.edit_rounded),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
          const SizedBox(height: 20),
          _Label('Start Date'),
          GestureDetector(
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                initialDate: _startDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme: const ColorScheme.light(primary: AppColors.primary),
                  ),
                  child: child!,
                ),
              );
              if (d != null) setState(() => _startDate = d);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
                color: AppColors.surface,
              ),
              child: Row(children: [
                const Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 20),
                const SizedBox(width: 12),
                Text(AppFormatters.date(_startDate), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          _Label('Number of Days'),
          _Counter(value: _days, min: 1, max: 7, suffix: _days == 1 ? 'day' : 'days', onChanged: (v) => setState(() => _days = v)),
          const SizedBox(height: 20),
          _Label('Number of Guests'),
          _Counter(value: _guests, min: 1, max: 20, suffix: _guests == 1 ? 'guest' : 'guests', onChanged: (v) => setState(() => _guests = v)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: List.generate(_days, (i) {
              final d = _startDate.add(Duration(days: i));
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Text('Day ${i + 1}  ${AppFormatters.dateShort(d)}',
                    style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
              );
            }),
          ),
          const SizedBox(height: 32),
          AppButton(
            label: 'Start Building My Itinerary',
            onPressed: () {
              if (_nameCtrl.text.trim().isEmpty) return;
              context.read<ItineraryProvider>().startNewItinerary(
                    tripName: _nameCtrl.text.trim(),
                    startDate: _startDate,
                    numberOfDays: _days,
                    guests: _guests,
                  );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─── STEP 2: BUILD ───────────────────────────────────────────────────────────

class _BuildStep extends StatefulWidget {
  const _BuildStep();
  @override
  State<_BuildStep> createState() => _BuildStepState();
}

class _BuildStepState extends State<_BuildStep> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final days = context.read<ItineraryProvider>().current?.numberOfDays ?? 1;
    _tabController = TabController(length: days, vsync: this);
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItineraryProvider>();
    final itinerary = provider.current!;

    return Column(
      children: [
        Container(
          color: AppColors.surface,
          child: TabBar(
            controller: _tabController,
            isScrollable: itinerary.numberOfDays > 3,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textHint,
            indicatorColor: AppColors.primary,
            tabs: List.generate(itinerary.numberOfDays, (i) => Tab(
              text: 'Day ${i + 1}\n${AppFormatters.dateShort(itinerary.days[i].date)}',
            )),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(itinerary.numberOfDays, (dayIdx) =>
              _DayBuilder(dayIndex: dayIdx, provider: provider)),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, -4))],
          ),
          child: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${itinerary.totalStops} stops added',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              Text('Est. ${AppFormatters.currency(itinerary.totalEstimatedCost * itinerary.guests)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
            ]),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                label: 'Review Itinerary →',
                onPressed: itinerary.totalStops > 0 ? () => context.read<ItineraryProvider>().setStep(2) : null,
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

class _DayBuilder extends StatelessWidget {
  final int dayIndex;
  final ItineraryProvider provider;
  const _DayBuilder({required this.dayIndex, required this.provider});

  @override
  Widget build(BuildContext context) {
    final day = provider.current!.days[dayIndex];
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(AppFormatters.date(day.date),
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ),
        ),
        if (day.stops.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _StopTile(
                  stop: day.stops[i],
                  onRemove: () => provider.removeStop(dayIndex: dayIndex, stopId: day.stops[i].id),
                ),
                childCount: day.stops.length,
              ),
            ),
          ),
        if (day.stops.isEmpty)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('Tap below to add stops for this day', style: TextStyle(color: AppColors.textHint, fontSize: 13))),
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('ADD TO DAY ${dayIndex + 1}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textHint, letterSpacing: 1)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _AddSectionButton(icon: Icons.landscape_rounded, label: 'Attractions', subtitle: '8 places in Basey', color: AppColors.primary,
                onTap: () => _showPicker(context, _PickerType.attraction, dayIndex)),
              _AddSectionButton(icon: Icons.restaurant_rounded, label: 'Restaurants & Cafés', subtitle: '4 local dining spots', color: AppColors.accent,
                onTap: () => _showPicker(context, _PickerType.restaurant, dayIndex)),
              _AddSectionButton(icon: Icons.hotel_rounded, label: 'Accommodations', subtitle: '4 stays in Basey', color: AppColors.success,
                onTap: () => _showPicker(context, _PickerType.accommodation, dayIndex)),
              _AddSectionButton(icon: Icons.auto_fix_high_rounded, label: 'Weaving Workshops', subtitle: '3 hands-on experiences', color: const Color(0xFF7B5EA7),
                onTap: () => _showPicker(context, _PickerType.weaving, dayIndex)),
            ]),
          ),
        ),
      ],
    );
  }

  void _showPicker(BuildContext context, _PickerType type, int dayIndex) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => ChangeNotifierProvider.value(
        value: provider,
        child: _StopPickerSheet(type: type, dayIndex: dayIndex),
      ),
    );
  }
}

enum _PickerType { attraction, restaurant, accommodation, weaving }

// ─── PICKER SHEET ─────────────────────────────────────────────────────────────

class _StopPickerSheet extends StatelessWidget {
  final _PickerType type;
  final int dayIndex;
  const _StopPickerSheet({required this.type, required this.dayIndex});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItineraryProvider>();

    String title;
    List<dynamic> items;

    switch (type) {
      case _PickerType.attraction:
        title = 'Attractions'; items = mockAttractions; break;
      case _PickerType.restaurant:
        title = 'Restaurants & Cafés'; items = itineraryRestaurants; break;
      case _PickerType.accommodation:
        title = 'Accommodations'; items = mockItineraryAccommodations; break;
      case _PickerType.weaving:
        title = 'Weaving Workshops'; items = mockWeavingExperiences; break;
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.75, minChildSize: 0.5, maxChildSize: 0.95, expand: false,
      builder: (_, ctrl) => Column(
        children: [
          const SizedBox(height: 8),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const Spacer(),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Done')),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              controller: ctrl,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
                final added = provider.isStopAdded(item.id, dayIndex);
                return _PickerCard(
                  item: item, type: type, isAdded: added,
                  onAdd: () {
                    if (!added) {
                      provider.addStop(dayIndex: dayIndex, stop: _buildStop(item, type));
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ItineraryStop _buildStop(dynamic item, _PickerType type) {
    final uniqueId = '${item.id}_${DateTime.now().millisecondsSinceEpoch}';
    switch (type) {
      case _PickerType.attraction:
        final a = item as AttractionModel;
        return ItineraryStop(id: uniqueId, type: StopType.attraction, timeSlot: TimeSlot.morning, itemId: a.id,
          name: a.name, imageUrl: a.imageUrl, cost: a.entryFee, icon: a.icon);
      case _PickerType.restaurant:
        final r = item as RestaurantModel;
        return ItineraryStop(id: uniqueId, type: StopType.restaurant, timeSlot: TimeSlot.afternoon, itemId: r.id,
          name: r.name, imageUrl: r.imageUrl, cost: r.averageMealCost.toDouble(), icon: Icons.restaurant_rounded);
      case _PickerType.accommodation:
        final acc = item as AccommodationModel;
        return ItineraryStop(id: uniqueId, type: StopType.accommodation, timeSlot: TimeSlot.evening, itemId: acc.id,
          name: acc.name, imageUrl: acc.imageUrl, cost: acc.pricePerNight, icon: Icons.hotel_rounded);
      case _PickerType.weaving:
        final w = item as AttractionModel;
        return ItineraryStop(id: uniqueId, type: StopType.weaving, timeSlot: TimeSlot.morning, itemId: w.id,
          name: w.name, imageUrl: w.imageUrl, cost: w.entryFee, icon: w.icon);
    }
  }
}

class _PickerCard extends StatelessWidget {
  final dynamic item;
  final _PickerType type;
  final bool isAdded;
  final VoidCallback onAdd;
  const _PickerCard({required this.item, required this.type, required this.isAdded, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    String name, desc, costLabel, imageUrl;

    if (item is AttractionModel) {
      final a = item as AttractionModel;
      name = a.name; desc = a.description; imageUrl = a.imageUrl;
      costLabel = a.entryFee == 0 ? 'Free entry' : '₱${a.entryFee.toStringAsFixed(0)}/person';
    } else if (item is RestaurantModel) {
      final r = item as RestaurantModel;
      name = r.name; desc = r.description; imageUrl = r.imageUrl;
      costLabel = '~₱${r.averageMealCost}/person · ${r.priceRange}';
    } else {
      final acc = item as AccommodationModel;
      name = acc.name; desc = acc.description; imageUrl = acc.imageUrl;
      costLabel = '₱${acc.pricePerNight.toStringAsFixed(0)}/night';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: isAdded ? AppColors.success.withOpacity(0.5) : AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
            child: Image.network(imageUrl, width: 90, height: 90, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(width: 90, height: 90, color: AppColors.tagBg)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text(costLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.accent)),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: onAdd,
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: isAdded ? AppColors.primary : AppColors.tagBg, shape: BoxShape.circle),
                child: Icon(isAdded ? Icons.check_rounded : Icons.add_rounded, color: isAdded ? Colors.white : AppColors.primary, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── STOP TILE ────────────────────────────────────────────────────────────────

class _StopTile extends StatelessWidget {
  final ItineraryStop stop;
  final VoidCallback onRemove;
  const _StopTile({required this.stop, required this.onRemove});

  Color _typeColor(StopType type) {
    switch (type) {
      case StopType.attraction: return AppColors.primary;
      case StopType.restaurant: return AppColors.accent;
      case StopType.accommodation: return AppColors.success;
      case StopType.weaving: return const Color(0xFF7B5EA7);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(stop.type);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: color.withOpacity(0.25)),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(stop.icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(stop.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(stop.typeLabel, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
                ),
                if (stop.cost > 0) ...[
                  const SizedBox(width: 8),
                  Text('₱${stop.cost.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ]),
            ]),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textHint),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}

// ─── STEP 3: REVIEW ──────────────────────────────────────────────────────────

class _ReviewStep extends StatelessWidget {
  const _ReviewStep();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItineraryProvider>();
    final it = provider.current!;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Icon(Icons.map_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(it.tripName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800))),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    _TripStat(Icons.calendar_today_rounded, '${AppFormatters.dateShort(it.startDate)} – ${AppFormatters.date(it.endDate)}'),
                    const SizedBox(width: 16),
                    _TripStat(Icons.people_rounded, '${it.guests} ${it.guests == 1 ? 'guest' : 'guests'}'),
                  ]),
                ]),
              ),
              const SizedBox(height: 16),
              ...it.days.map((day) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(children: [
                        Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                          child: Center(child: Text('${day.dayNumber}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700))),
                        ),
                        const SizedBox(width: 10),
                        Text(AppFormatters.date(day.date), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                    ...day.stops.map((s) => _ReviewStopTile(stop: s)),
                    const SizedBox(height: 12),
                  ],
                );
              }),
              const Divider(),
              const SizedBox(height: 12),
              _CostRow('Estimated entry fees & dining', AppFormatters.currency(it.totalEstimatedCost * it.guests)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                ),
                child: Row(children: [
                  const Text('Total Estimated Cost', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  Text(AppFormatters.currency(it.totalEstimatedCost * it.guests),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
                ]),
              ),
              const SizedBox(height: 8),
              const Text('* Accommodation costs are per night, not per person.',
                  style: TextStyle(fontSize: 11, color: AppColors.textHint)),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, -4))],
          ),
          child: Column(children: [
            AppButton(
              label: 'Confirm & Book This Itinerary',
              onPressed: () => _confirmBooking(context, provider, it),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => provider.setStep(1),
              child: const Text('← Back to Edit', style: TextStyle(color: AppColors.textSecondary)),
            ),
          ]),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ██  THIS IS THE KEY FIX: Actually save the itinerary as a booking!
  // ═══════════════════════════════════════════════════════════════════════════
  void _confirmBooking(BuildContext context, ItineraryProvider provider, ItineraryModel it) {
    // 1. Get the logged-in user
    final user = context.read<AuthProvider>().user;
    if (user == null) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    // 2. Create a REAL booking in BookingProvider so it shows in My Bookings
    context.read<BookingProvider>().createBooking(
      userId: user.id,
      userName: user.name,
      userEmail: user.email,
      itemId: 'itinerary_${it.id}',
      itemName: '${it.tripName} (${it.numberOfDays}-Day Custom Itinerary)',
      itemImage: 'https://images.unsplash.com/photo-1527631746610-bca00a040d60?w=400',
      type: BookingType.tour,
      checkIn: it.startDate,
      checkOut: it.endDate,
      guests: it.guests,
      totalAmount: it.totalEstimatedCost * it.guests,
      notes: '${it.totalStops} stops planned across ${it.numberOfDays} days',
    );

    // 3. Show confirmation dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.check_circle_rounded, color: AppColors.success, size: 28),
          SizedBox(width: 10),
          Expanded(child: Text('Itinerary Booked!')),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your trip "${it.tripName}" has been saved to your bookings.',
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            _ReviewStat(Icons.calendar_today_rounded,
                '${AppFormatters.dateShort(it.startDate)} – ${AppFormatters.date(it.endDate)}'),
            _ReviewStat(Icons.place_rounded, '${it.totalStops} stops planned'),
            _ReviewStat(Icons.people_rounded, '${it.guests} ${it.guests == 1 ? 'guest' : 'guests'}'),
            _ReviewStat(Icons.payments_rounded, 'Est. ${AppFormatters.currency(it.totalEstimatedCost * it.guests)}'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'A local iWeave guide will contact you within 24 hours to confirm all bookings and arrange logistics.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              provider.confirm();
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pushReplacementNamed('/bookings');
            },
            child: const Text('View My Bookings'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.confirm();
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pushReplacementNamed('/main', arguments: 0);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class _ReviewStopTile extends StatelessWidget {
  final ItineraryStop stop;
  const _ReviewStopTile({required this.stop});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, left: 38),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        Icon(stop.icon, size: 16, color: AppColors.textHint),
        const SizedBox(width: 10),
        Expanded(child: Text(stop.name, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary))),
        Text(stop.cost > 0 ? '₱${stop.cost.toStringAsFixed(0)}' : 'Free',
            style: const TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// ─── SHARED WIDGETS ───────────────────────────────────────────────────────────

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
  );
}

class _Counter extends StatelessWidget {
  final int value, min, max;
  final String suffix;
  final ValueChanged<int> onChanged;
  const _Counter({required this.value, required this.min, required this.max, required this.suffix, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12), color: AppColors.surface),
      child: Row(children: [
        IconButton(
          onPressed: value > min ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove_circle_outline_rounded),
          color: value > min ? AppColors.primary : AppColors.textHint,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36), padding: EdgeInsets.zero,
        ),
        Expanded(child: Center(child: Text('$value $suffix', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)))),
        IconButton(
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add_circle_outline_rounded),
          color: value < max ? AppColors.primary : AppColors.textHint,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36), padding: EdgeInsets.zero,
        ),
      ]),
    );
  }
}

class _AddSectionButton extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final Color color;
  final VoidCallback onTap;
  const _AddSectionButton({required this.icon, required this.label, required this.subtitle, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4)],
        ),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ])),
          Icon(Icons.chevron_right_rounded, color: color),
        ]),
      ),
    );
  }
}

class _TripStat extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TripStat(this.icon, this.label);
  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, color: Colors.white70, size: 14),
    const SizedBox(width: 4),
    Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
  ]);
}

class _CostRow extends StatelessWidget {
  final String label, value;
  const _CostRow(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(children: [
      Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      const Spacer(),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
    ]),
  );
}

class _ReviewStat extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ReviewStat(this.icon, this.label);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(children: [
      Icon(icon, size: 14, color: AppColors.textHint),
      const SizedBox(width: 8),
      Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
    ]),
  );
}