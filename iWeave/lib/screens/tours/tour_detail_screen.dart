import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/formatters.dart';
import '../../providers/tour_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking_model.dart';

class TourDetailScreen extends StatefulWidget {
  final String tourId;
  const TourDetailScreen({super.key, required this.tourId});
  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  DateTime? _checkIn;
  int _guests = 2;
  bool _isBooking = false;

  @override
  Widget build(BuildContext context) {
    final tour = context.read<TourProvider>().getTourById(widget.tourId);
    if (tour == null) return const Scaffold(body: Center(child: Text('Tour not found')));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260, pinned: true,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                onPressed: () => context.read<TourProvider>().toggleTourFavorite(tour.id),
                icon: Icon(tour.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share_rounded, color: Colors.white),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(tour.imageUrl, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: AppColors.primary)),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tour.isTouristFavorite)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.favorite_rounded, size: 12, color: AppColors.primary),
                        const SizedBox(width: 4),
                        const Text('Tourist Favorite', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  Text(tour.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, height: 1.3)),
                  const SizedBox(height: 12),
                  Row(children: [
                    _InfoChip(Icons.schedule_rounded, '${tour.durationDays} ${tour.durationDays == 1 ? 'day' : 'days'}'),
                    const SizedBox(width: 8),
                    _InfoChip(Icons.access_time_rounded, tour.startTime),
                    const SizedBox(width: 8),
                    if (tour.pickupOffered) _InfoChip(Icons.directions_car_rounded, 'Pickup'),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    _InfoChip(Icons.translate_rounded, tour.languages.take(2).join(', ')),
                  ]),
                  const SizedBox(height: 16),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.star.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(children: [
                        const Icon(Icons.star_rounded, size: 16, color: AppColors.star),
                        const SizedBox(width: 4),
                        Text('${tour.rating}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                      ]),
                    ),
                    const SizedBox(width: 8),
                    Text('${tour.reviewCount} reviews · Operated by: ${tour.operator}',
                      style: const TextStyle(fontSize: 13, color: AppColors.textHint)),
                  ]),
                  const SizedBox(height: 20),
                  const Text('Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(tour.description, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.7)),
                  const SizedBox(height: 20),
                  const Text('What\'s included', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  ...tour.highlights.map((h) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.success),
                      const SizedBox(width: 8),
                      Expanded(child: Text(h, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5))),
                    ]),
                  )),
                  const SizedBox(height: 24),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 16),
                  const Text('Select Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 3)),
                        firstDate: DateTime.now().add(const Duration(days: 1)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (_, child) => Theme(
                          data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: AppColors.primary)),
                          child: child!,
                        ),
                      );
                      if (d != null) setState(() => _checkIn = d);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(color: _checkIn != null ? AppColors.primary : AppColors.border),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        color: _checkIn != null ? AppColors.tagBg : null,
                      ),
                      child: Row(children: [
                        const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Text(
                          _checkIn != null ? AppFormatters.date(_checkIn!) : 'Choose your date',
                          style: TextStyle(fontSize: 14, color: _checkIn != null ? AppColors.textPrimary : AppColors.textHint, fontWeight: FontWeight.w500),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(children: [
                    const Text('Number of guests:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => _guests = (_guests - 1).clamp(1, 20)),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.remove, size: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('$_guests', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _guests++),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.add, size: 16, color: Colors.white),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, -4))],
          ),
          child: Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
              children: [
                if (tour.originalPrice > 0)
                  Text(AppFormatters.currency(tour.originalPrice * _guests),
                    style: const TextStyle(fontSize: 12, color: AppColors.textHint, decoration: TextDecoration.lineThrough)),
                Text(AppFormatters.currency(tour.price * _guests),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary)),
                Text('for $_guests ${_guests == 1 ? 'person' : 'people'}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _isBooking ? null : () => _book(context, tour),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent, minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _isBooking
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Book Your Tour', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _book(BuildContext context, dynamic tour) async {
    final user = context.read<AuthProvider>().user;
    if (user == null) { Navigator.pushNamed(context, '/login'); return; }
    if (_checkIn == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date first'), backgroundColor: AppColors.warning),
      );
      return;
    }
    setState(() => _isBooking = true);
    await context.read<BookingProvider>().createBooking(
      userId: user.id, itemId: tour.id, itemName: tour.title,
      itemImage: tour.imageUrl, type: BookingType.tour,
      checkIn: _checkIn!, checkOut: _checkIn!.add(Duration(days: tour.durationDays)),
      guests: _guests, totalAmount: tour.price * _guests,
    );
    setState(() => _isBooking = false);
    if (mounted) _showBookingSuccess(context, tour);
  }

  void _showBookingSuccess(BuildContext context, dynamic tour) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: AppColors.tagBg, shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_rounded, size: 56, color: AppColors.success),
            ),
            const SizedBox(height: 16),
            const Text('Booking Confirmed!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Your ${tour.title} has been booked. Check your notifications for updates.',
              textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () { Navigator.pop(context); Navigator.pop(context); },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48), backgroundColor: AppColors.primary),
              child: const Text('View My Bookings', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.tagBg, borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.tagText, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
