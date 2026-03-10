import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/formatters.dart';
import '../../providers/admin_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/booking_model.dart';
import '../../models/order_model.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadDashboard();
      context.read<BookingProvider>().loadAllBookings();
      context.read<OrderProvider>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final bookings = context.watch<BookingProvider>();
    final orders = context.watch<OrderProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 130, pinned: true,
            backgroundColor: AppColors.primaryDark,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.primaryDark, AppColors.primary], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Admin Dashboard', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                              Text('iWeave Management', style: TextStyle(color: Colors.white70, fontSize: 13)),
                            ],
                          )),
                          IconButton(
                            onPressed: () => _refreshAll(context),
                            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: () async {
                              await context.read<AuthProvider>().logout();
                              if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
                            },
                            icon: const Icon(Icons.logout_rounded, color: Colors.white70),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: admin.isLoading
              ? const Padding(padding: EdgeInsets.all(48), child: Center(child: CircularProgressIndicator(color: AppColors.primary)))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // Revenue Stats
                    _buildRevenueCard(admin.stats),
                    const SizedBox(height: 14),

                    // Quick Stats Row
                    Row(children: [
                      _StatTile('Bookings', '${admin.stats['totalBookings'] ?? 0}', Icons.calendar_today_rounded, AppColors.primary,
                        onTap: () => Navigator.pushNamed(context, '/admin-bookings')),
                      const SizedBox(width: 10),
                      _StatTile('Orders', '${admin.stats['totalOrders'] ?? 0}', Icons.shopping_bag_rounded, AppColors.accent,
                        onTap: () => Navigator.pushNamed(context, '/admin-orders')),
                      const SizedBox(width: 10),
                      _StatTile('Users', '${admin.stats['totalUsers'] ?? 0}', Icons.people_rounded, AppColors.success,
                        onTap: () => Navigator.pushNamed(context, '/admin-users')),
                    ]),

                    const SizedBox(height: 24),

                    // Quick Actions
                    const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Row(children: [
                      _ActionChip(Icons.calendar_today_rounded, 'All Bookings', AppColors.primary,
                        () => Navigator.pushNamed(context, '/admin-bookings')),
                      const SizedBox(width: 10),
                      _ActionChip(Icons.shopping_bag_rounded, 'All Orders', AppColors.accent,
                        () => Navigator.pushNamed(context, '/admin-orders')),
                      const SizedBox(width: 10),
                      _ActionChip(Icons.group_rounded, 'Users', AppColors.success,
                        () => Navigator.pushNamed(context, '/admin-users')),
                    ]),

                    const SizedBox(height: 24),

                    // Recent Bookings
                    _SectionHeader('Recent Bookings', onSeeAll: () => Navigator.pushNamed(context, '/admin-bookings')),
                    const SizedBox(height: 10),
                    if (bookings.bookings.isEmpty)
                      _EmptyMini('No bookings yet')
                    else
                      ...bookings.bookings.take(3).map((b) => _BookingMiniCard(
                        booking: b,
                        onTap: () => Navigator.pushNamed(context, '/booking-detail', arguments: b.id),
                      )),

                    const SizedBox(height: 20),

                    // Recent Orders
                    _SectionHeader('Recent Orders', onSeeAll: () => Navigator.pushNamed(context, '/admin-orders')),
                    const SizedBox(height: 10),
                    if (orders.orders.isEmpty)
                      _EmptyMini('No orders yet')
                    else
                      ...orders.orders.take(3).map((o) => _OrderMiniCard(order: o)),

                    const SizedBox(height: 32),
                  ]),
                ),
          ),
        ],
      ),
    );
  }

  void _refreshAll(BuildContext context) {
    context.read<AdminProvider>().loadDashboard();
    context.read<BookingProvider>().loadAllBookings();
    context.read<OrderProvider>().loadOrders();
  }

  Widget _buildRevenueCard(Map<String, dynamic> stats) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Total Revenue', style: TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 4),
        Text(AppFormatters.currency((stats['totalRevenue'] as num?)?.toDouble() ?? 0),
          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Row(children: [
          _RevenuePill('Bookings', AppFormatters.currency((stats['bookingRevenue'] as num?)?.toDouble() ?? 0)),
          const SizedBox(width: 12),
          _RevenuePill('Orders', AppFormatters.currency((stats['orderRevenue'] as num?)?.toDouble() ?? 0)),
        ]),
      ]),
    );
  }
}

// ─── WIDGETS ────────────────────────────────────────────────────────────────

class _StatTile extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  const _StatTile(this.label, this.value, this.icon, this.color, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
          ]),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionChip(this.icon, this.label, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color), textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }
}

class _RevenuePill extends StatelessWidget {
  final String label, value;
  const _RevenuePill(this.label, this.value);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
    child: Text('$label: $value', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
  );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  const _SectionHeader(this.title, {this.onSeeAll});
  @override
  Widget build(BuildContext context) => Row(children: [
    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
    const Spacer(),
    if (onSeeAll != null) GestureDetector(onTap: onSeeAll, child: const Text('See All →', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600))),
  ]);
}

class _EmptyMini extends StatelessWidget {
  final String text;
  const _EmptyMini(this.text);
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
    child: Center(child: Text(text, style: const TextStyle(color: AppColors.textHint, fontSize: 13))),
  );
}

class _BookingMiniCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onTap;
  const _BookingMiniCard({required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4)],
        ),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(booking.itemImage, width: 48, height: 48, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(width: 48, height: 48, color: AppColors.tagBg)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(booking.itemName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text('${booking.guests} guests · ${AppFormatters.currency(booking.totalAmount)}',
              style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
          ])),
          _StatusBadge(booking.statusLabel, _bookingStatusColor(booking.status)),
        ]),
      ),
    );
  }

  Color _bookingStatusColor(BookingStatus s) {
    switch (s) {
      case BookingStatus.pending: return AppColors.warning;
      case BookingStatus.confirmed: return AppColors.success;
      case BookingStatus.completed: return AppColors.info;
      case BookingStatus.cancelled: return AppColors.error;
    }
  }
}

class _OrderMiniCard extends StatelessWidget {
  final OrderModel order;
  const _OrderMiniCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4)],
      ),
      child: Row(children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text('${order.totalItems}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.accent))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(order.userName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text('${order.totalItems} items · ${AppFormatters.currency(order.totalAmount)}',
            style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
        ])),
        _StatusBadge(order.statusLabel, _orderStatusColor(order.status)),
      ]),
    );
  }

  Color _orderStatusColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending: return AppColors.warning;
      case OrderStatus.processing: return AppColors.info;
      case OrderStatus.shipped: return AppColors.primary;
      case OrderStatus.delivered: return AppColors.success;
      case OrderStatus.cancelled: return AppColors.error;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
    child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
  );
}
