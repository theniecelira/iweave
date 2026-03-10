import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/formatters.dart';
import '../../models/booking_model.dart';
import '../../providers/booking_provider.dart';

class BookingDetailScreen extends StatelessWidget {
  final String bookingId;
  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    final booking = provider.bookings.cast<BookingModel?>().firstWhere(
      (b) => b?.id == bookingId,
      orElse: () => null,
    );

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Booking Details')),
        body: const Center(child: Text('Booking not found')),
      );
    }

    final statusColor = _statusColor(booking.status);
    final durationDays = (booking.checkIn != null && booking.checkOut != null)
        ? booking.checkOut!.difference(booking.checkIn!).inDays
        : 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero image
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    booking.itemImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.tagBg,
                      child: const Icon(Icons.image_not_supported, size: 48, color: AppColors.textHint),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                      ),
                    ),
                  ),
                  // Status badge + type badge at bottom
                  Positioned(
                    bottom: 16, left: 16, right: 16,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            booking.statusLabel,
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _typeLabel(booking.type),
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    booking.itemName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Booked on ${AppFormatters.date(booking.bookingDate)}',
                    style: const TextStyle(fontSize: 13, color: AppColors.textHint),
                  ),

                  const SizedBox(height: 20),

                  // Booking Info Card
                  _SectionCard(
                    title: 'Booking Information',
                    icon: Icons.info_outline_rounded,
                    child: Column(
                      children: [
                        _DetailRow('Booking ID', booking.id.toUpperCase()),
                        _DetailRow('Type', _typeLabel(booking.type)),
                        _DetailRow('Status', booking.statusLabel, valueColor: statusColor),
                        if (booking.notes != null && booking.notes!.isNotEmpty)
                          _DetailRow('Notes', booking.notes!),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Schedule Card
                  if (booking.checkIn != null)
                    _SectionCard(
                      title: 'Schedule',
                      icon: Icons.calendar_today_rounded,
                      child: Column(
                        children: [
                          _DetailRow('Check-in', AppFormatters.date(booking.checkIn!)),
                          if (booking.checkOut != null)
                            _DetailRow('Check-out', AppFormatters.date(booking.checkOut!)),
                          if (durationDays > 0)
                            _DetailRow('Duration', '$durationDays ${durationDays == 1 ? 'day' : 'days'}'),
                        ],
                      ),
                    ),

                  if (booking.checkIn != null) const SizedBox(height: 14),

                  // Guests Card
                  _SectionCard(
                    title: 'Guests',
                    icon: Icons.people_rounded,
                    child: Column(
                      children: [
                        _DetailRow('Number of Guests', '${booking.guests} ${booking.guests == 1 ? 'person' : 'people'}'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Cost Breakdown
                  _SectionCard(
                    title: 'Cost Breakdown',
                    icon: Icons.receipt_long_rounded,
                    child: Column(
                      children: [
                        if (booking.guests > 1 && booking.type == BookingType.tour)
                          _DetailRow(
                            'Price per guest',
                            AppFormatters.currency(booking.totalAmount / booking.guests),
                          ),
                        if (booking.guests > 1 && booking.type == BookingType.tour)
                          _DetailRow('× ${booking.guests} guests', ''),
                        if (durationDays > 0 && booking.type == BookingType.accommodation)
                          _DetailRow(
                            'Price per night',
                            AppFormatters.currency(booking.totalAmount / durationDays),
                          ),
                        if (durationDays > 0 && booking.type == BookingType.accommodation)
                          _DetailRow('× $durationDays nights', ''),
                        const Divider(color: AppColors.divider, height: 20),
                        Row(
                          children: [
                            const Text('Total Amount',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                            const Spacer(),
                            Text(
                              AppFormatters.currency(booking.totalAmount),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Status Timeline
                  _SectionCard(
                    title: 'Booking Timeline',
                    icon: Icons.timeline_rounded,
                    child: Column(
                      children: [
                        _TimelineStep(
                          title: 'Booking Placed',
                          subtitle: AppFormatters.date(booking.bookingDate),
                          isCompleted: true,
                          isFirst: true,
                        ),
                        _TimelineStep(
                          title: booking.status == BookingStatus.cancelled ? 'Cancelled' : 'Confirmed',
                          subtitle: booking.status == BookingStatus.cancelled
                              ? 'This booking was cancelled'
                              : booking.status == BookingStatus.pending
                                  ? 'Awaiting confirmation'
                                  : 'Your booking is confirmed',
                          isCompleted: booking.status != BookingStatus.pending,
                          isError: booking.status == BookingStatus.cancelled,
                        ),
                        if (booking.status != BookingStatus.cancelled)
                          _TimelineStep(
                            title: 'Completed',
                            subtitle: booking.status == BookingStatus.completed
                                ? 'Experience completed'
                                : 'After your trip ends',
                            isCompleted: booking.status == BookingStatus.completed,
                            isLast: true,
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Contact support
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                      border: Border.all(color: AppColors.accent.withOpacity(0.2)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.support_agent_rounded, size: 20, color: AppColors.accent),
                            SizedBox(width: 8),
                            Text('Need Help?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Our local iWeave guide is available to assist you with any changes or questions about your booking.',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Action buttons
                  if (booking.status == BookingStatus.confirmed) ...[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _confirmCancel(context, provider, booking.id),
                        icon: const Icon(Icons.cancel_outlined, size: 18),
                        label: const Text('Cancel This Booking'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusL)),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmCancel(BuildContext context, BookingProvider provider, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.cancelBooking(id);
              Navigator.pop(context); // close dialog
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Cancel Booking', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Color _statusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending: return AppColors.warning;
      case BookingStatus.confirmed: return AppColors.success;
      case BookingStatus.completed: return AppColors.info;
      case BookingStatus.cancelled: return AppColors.error;
    }
  }

  String _typeLabel(BookingType type) {
    switch (type) {
      case BookingType.tour: return 'Tour';
      case BookingType.accommodation: return 'Accommodation';
      case BookingType.product: return 'Product';
    }
  }
}

// ─── Section Card ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _SectionCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ]),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ─── Detail Row ───────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _DetailRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: valueColor ?? AppColors.textPrimary),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Timeline Step ────────────────────────────────────────────────────────────

class _TimelineStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isFirst;
  final bool isLast;
  final bool isError;

  const _TimelineStep({
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
    this.isFirst = false,
    this.isLast = false,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isError
        ? AppColors.error
        : isCompleted
            ? AppColors.success
            : AppColors.border;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                if (!isFirst)
                  Container(width: 2, height: 8, color: color),
                Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(
                    color: isCompleted || isError ? color : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: isCompleted || isError
                      ? Icon(
                          isError ? Icons.close_rounded : Icons.check_rounded,
                          size: 10,
                          color: Colors.white,
                        )
                      : null,
                ),
                if (!isLast)
                  Expanded(child: Container(width: 2, color: color)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isError ? AppColors.error : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
