import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/formatters.dart';
import '../../models/booking_model.dart';
import '../../providers/booking_provider.dart';
import '../../providers/admin_provider.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});
  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen> {
  BookingStatus? _filter;
  String _search = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().loadAllBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    final filtered = provider.bookings.where((b) {
      final matchStatus = _filter == null || b.status == _filter;
      final matchSearch = _search.isEmpty ||
          b.itemName.toLowerCase().contains(_search.toLowerCase()) ||
          b.id.toLowerCase().contains(_search.toLowerCase()) ||
          b.userName.toLowerCase().contains(_search.toLowerCase()) ||
          b.userEmail.toLowerCase().contains(_search.toLowerCase());
      return matchStatus && matchSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Bookings (${provider.bookings.length})'),
        actions: [
          IconButton(
            onPressed: () => context.read<BookingProvider>().loadAllBookings(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search by guest name, email, item or ID...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                _FilterChip('All', _filter == null, () => setState(() => _filter = null)),
                ...BookingStatus.values.map((s) => _FilterChip(
                  s.name[0].toUpperCase() + s.name.substring(1),
                  _filter == s,
                  () => setState(() => _filter = s),
                )),
              ]),
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : filtered.isEmpty
                    ? const Center(
                        child: Text('No bookings found',
                            style: TextStyle(color: AppColors.textHint)))
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) => _AdminBookingCard(
                          booking: filtered[i],
                          onStatusChange: (s) => _changeStatus(context, filtered[i], s),
                          onDelete: () => _confirmDelete(context, filtered[i]),
                          onTap: () => Navigator.pushNamed(
                            context, '/booking-detail',
                            arguments: filtered[i].id,
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void _changeStatus(
      BuildContext context, BookingModel booking, BookingStatus newStatus) async {
    await context.read<BookingProvider>().updateStatus(booking.id, newStatus);
    context.read<AdminProvider>().refreshStats();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Booking updated to ${newStatus.name}'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  void _confirmDelete(BuildContext context, BookingModel booking) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Booking'),
        content: Text('Permanently delete "${booking.itemName}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await context.read<BookingProvider>().deleteBooking(booking.id);
              context.read<AdminProvider>().refreshStats();
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _FilterChip(this.label, this.isActive, this.onTap);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: isActive ? AppColors.primary : AppColors.border),
            ),
            child: Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : AppColors.textSecondary)),
          ),
        ),
      );
}

class _AdminBookingCard extends StatelessWidget {
  final BookingModel booking;
  final Function(BookingStatus) onStatusChange;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  const _AdminBookingCard({
    required this.booking,
    required this.onStatusChange,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _color(booking.status);
    // Display name: use userName if stored, else fall back to userId
    final displayName = booking.userName.isNotEmpty ? booking.userName : booking.userId;
    final displayEmail = booking.userEmail.isNotEmpty ? booking.userEmail : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                booking.itemImage,
                width: 50, height: 50, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(width: 50, height: 50, color: AppColors.tagBg),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(booking.itemName,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                // ── GUEST INFO ──────────────────────────────────────────
                Row(children: [
                  const Icon(Icons.person_rounded,
                      size: 13, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(displayName,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                ]),
                if (displayEmail != null)
                  Row(children: [
                    const Icon(Icons.email_outlined,
                        size: 12, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text(displayEmail,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textHint)),
                  ]),
                // ────────────────────────────────────────────────────────
                const SizedBox(height: 2),
                Text(
                  '${booking.guests} guest${booking.guests != 1 ? 's' : ''} · ${AppFormatters.currency(booking.totalAmount)}',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
              ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(booking.statusLabel,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: statusColor)),
              ),
              const SizedBox(height: 4),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded,
                    size: 18, color: AppColors.error),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ]),
          ]),

          if (booking.checkIn != null) ...[
            const SizedBox(height: 8),
            Text(
              '${AppFormatters.date(booking.checkIn!)} → ${booking.checkOut != null ? AppFormatters.date(booking.checkOut!) : '?'}',
              style: const TextStyle(fontSize: 11, color: AppColors.textHint),
            ),
          ],

          const SizedBox(height: 10),

          // Status update row
          Row(children: [
            const Text('Update:',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            const SizedBox(width: 6),
            ...BookingStatus.values.map((s) => Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: GestureDetector(
                    onTap: s != booking.status ? () => onStatusChange(s) : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: s == booking.status
                            ? _color(s)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: _color(s).withOpacity(0.4)),
                      ),
                      child: Text(
                        _shortLabel(s),
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: s == booking.status
                                ? Colors.white
                                : _color(s)),
                      ),
                    ),
                  ),
                )),
          ]),
        ]),
      ),
    );
  }

  String _shortLabel(BookingStatus s) {
    switch (s) {
      case BookingStatus.pending:   return 'PND';
      case BookingStatus.confirmed: return 'CNF';
      case BookingStatus.completed: return 'CMP';
      case BookingStatus.cancelled: return 'CXL';
    }
  }

  Color _color(BookingStatus s) {
    switch (s) {
      case BookingStatus.pending:   return AppColors.warning;
      case BookingStatus.confirmed: return AppColors.success;
      case BookingStatus.completed: return AppColors.primary;
      case BookingStatus.cancelled: return AppColors.error;
    }
  }
}