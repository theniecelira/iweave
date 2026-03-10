import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/formatters.dart';
import '../../models/booking_model.dart';
import '../../models/order_model.dart';
import '../../providers/booking_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/loading_widget.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});
  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().user?.id ?? '';
      context.read<BookingProvider>().loadBookings(userId);
      context.read<OrderProvider>().loadOrders(userId: userId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Activity'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(icon: Icon(Icons.calendar_today_rounded, size: 18), text: 'Bookings'),
            Tab(icon: Icon(Icons.shopping_bag_rounded, size: 18), text: 'Orders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _BookingsTab(),
          _OrdersTab(),
        ],
      ),
    );
  }
}

// ─── BOOKINGS TAB ─────────────────────────────────────────────────────────────

class _BookingsTab extends StatelessWidget {
  const _BookingsTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    if (provider.isLoading) return const LoadingWidget(message: 'Loading bookings...');
    if (provider.bookings.isEmpty) {
      return EmptyStateWidget(
        title: 'No bookings yet',
        subtitle: 'Your tour and accommodation bookings will appear here',
        icon: Icons.calendar_today_rounded,
        actionLabel: 'Explore Tours',
        onAction: () => Navigator.pushNamed(context, '/tours'),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: provider.bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final b = provider.bookings[i];
        return _BookingCard(
          booking: b,
          onCancel: b.status == BookingStatus.confirmed
              ? () => _confirmCancel(context, provider, b.id)
              : null,
          onViewDetails: () =>
              Navigator.pushNamed(context, '/booking-detail', arguments: b.id),
        );
      },
    );
  }

  void _confirmCancel(
      BuildContext context, BookingProvider provider, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text(
            'Are you sure you want to cancel this booking? This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Keep Booking')),
          ElevatedButton(
            onPressed: () {
              provider.cancelBooking(id);
              Navigator.pop(context);
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }
}

// ─── ORDERS TAB ───────────────────────────────────────────────────────────────

class _OrdersTab extends StatelessWidget {
  const _OrdersTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    if (provider.isLoading) return const LoadingWidget(message: 'Loading orders...');
    if (provider.orders.isEmpty) {
      return EmptyStateWidget(
        title: 'No orders yet',
        subtitle: 'Products you order will appear here so you can track their progress',
        icon: Icons.shopping_bag_outlined,
        actionLabel: 'Browse Products',
        onAction: () => Navigator.pushNamed(context, '/products'),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: provider.orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _OrderCard(order: provider.orders[i]),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header row
        Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Order #${order.id.replaceFirst('ord_', '')}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              Text(AppFormatters.date(order.orderDate),
                  style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _statusColor(order.status).withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(order.statusLabel,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _statusColor(order.status))),
          ),
        ]),

        const SizedBox(height: 12),
        const Divider(height: 1, color: AppColors.divider),
        const SizedBox(height: 12),

        // Items
        ...order.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.productImage, width: 52, height: 52, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(width: 52, height: 52, color: AppColors.tagBg),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.productName,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text('by ${item.weaverName}',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textHint)),
                    if (item.selectedColor != null || item.selectedMaterial != null)
                      Text(
                        [
                          if (item.selectedMaterial != null) item.selectedMaterial!,
                          if (item.selectedColor != null) item.selectedColor!,
                        ].join(' · '),
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textHint),
                      ),
                    if (item.giftWrap)
                      const Text('🎁 Gift wrapped',
                          style: TextStyle(
                              fontSize: 11, color: AppColors.accent)),
                  ]),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('×${item.quantity}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textHint)),
                  Text(AppFormatters.currency(item.totalPrice),
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                ]),
              ]),
            )),

        const Divider(height: 1, color: AppColors.divider),
        const SizedBox(height: 10),

        // Total & progress
        Row(children: [
          const Text('Total',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          const Spacer(),
          Text(AppFormatters.currency(order.totalAmount),
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary)),
        ]),

        const SizedBox(height: 12),

        // Status progress stepper
        _OrderStepper(status: order.status),
      ]),
    );
  }

  Color _statusColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:    return AppColors.warning;
      case OrderStatus.processing: return const Color(0xFF1565C0);
      case OrderStatus.shipped:    return AppColors.primary;
      case OrderStatus.delivered:  return AppColors.success;
      case OrderStatus.cancelled:  return AppColors.error;
    }
  }
}

class _OrderStepper extends StatelessWidget {
  final OrderStatus status;
  const _OrderStepper({required this.status});

  static const _steps = [
    (OrderStatus.pending,    Icons.receipt_long_rounded,    'Placed'),
    (OrderStatus.processing, Icons.auto_fix_high_rounded,   'Being Woven'),
    (OrderStatus.shipped,    Icons.local_shipping_rounded,  'Shipped'),
    (OrderStatus.delivered,  Icons.check_circle_rounded,    'Delivered'),
  ];

  @override
  Widget build(BuildContext context) {
    if (status == OrderStatus.cancelled) {
      return Row(children: [
        const Icon(Icons.cancel_rounded, size: 16, color: AppColors.error),
        const SizedBox(width: 6),
        const Text('Order Cancelled',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.error)),
      ]);
    }

    final currentIdx = _steps.indexWhere((s) => s.$1 == status);

    return Row(
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // connector line
          final stepIdx = i ~/ 2;
          final isCompleted = stepIdx < currentIdx;
          return Expanded(
            child: Container(
              height: 2,
              color: isCompleted ? AppColors.primary : AppColors.border,
            ),
          );
        }
        final stepIdx = i ~/ 2;
        final isCompleted = stepIdx <= currentIdx;
        final isCurrent = stepIdx == currentIdx;
        final step = _steps[stepIdx];
        return Column(children: [
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? AppColors.primary : AppColors.border,
              border: isCurrent
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
            ),
            child: Icon(step.$2,
                size: 15,
                color: isCompleted ? Colors.white : AppColors.textHint),
          ),
          const SizedBox(height: 4),
          Text(step.$3,
              style: TextStyle(
                  fontSize: 9,
                  fontWeight:
                      isCurrent ? FontWeight.w700 : FontWeight.w400,
                  color: isCompleted
                      ? AppColors.primary
                      : AppColors.textHint)),
        ]);
      }),
    );
  }
}

// ─── BOOKING CARD (unchanged from original) ──────────────────────────────────

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onCancel;
  final VoidCallback onViewDetails;
  const _BookingCard(
      {required this.booking,
      this.onCancel,
      required this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDimensions.radiusL)),
            child: Stack(
              children: [
                Image.network(booking.itemImage,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(height: 130, color: AppColors.tagBg)),
                Positioned(
                  top: 10, right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _statusColor(booking.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(booking.statusLabel,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
                Positioned(
                  top: 10, left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      booking.type.name[0].toUpperCase() +
                          booking.type.name.substring(1),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.itemName,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.calendar_today_rounded,
                      size: 13, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Text(AppFormatters.date(booking.bookingDate),
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textHint)),
                  const Spacer(),
                  Text(AppFormatters.currency(booking.totalAmount),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary)),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onViewDetails,
                      style: OutlinedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 10),
                          side:
                              const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text('View Details',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.primary)),
                    ),
                  ),
                  if (onCancel != null) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCancel,
                        style: OutlinedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 10),
                            side: const BorderSide(
                                color: AppColors.error),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10))),
                        child: const Text('Cancel',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColors.error)),
                      ),
                    ),
                  ],
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(BookingStatus s) {
    switch (s) {
      case BookingStatus.pending:    return AppColors.warning;
      case BookingStatus.confirmed:  return AppColors.success;
      case BookingStatus.completed:  return AppColors.primary;
      case BookingStatus.cancelled:  return AppColors.error;
    }
  }
}