import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/formatters.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../providers/admin_provider.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});
  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  OrderStatus? _filter;
  String _search = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    final filtered = provider.orders.where((o) {
      final matchStatus = _filter == null || o.status == _filter;
      final matchSearch = _search.isEmpty ||
          o.userName.toLowerCase().contains(_search.toLowerCase()) ||
          o.id.toLowerCase().contains(_search.toLowerCase()) ||
          o.items.any((i) => i.productName.toLowerCase().contains(_search.toLowerCase()));
      return matchStatus && matchSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Orders (${provider.orders.length})'),
        actions: [
          IconButton(onPressed: () => provider.loadOrders(), icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search orders by name, ID, or product...',
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
                ...OrderStatus.values.map((s) =>
                  _FilterChip(s == OrderStatus.processing ? 'Being Woven' : s.name[0].toUpperCase() + s.name.substring(1),
                    _filter == s, () => setState(() => _filter = s))),
              ]),
            ),
          ),
          Expanded(
            child: provider.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : filtered.isEmpty
                ? const Center(child: Text('No orders found', style: TextStyle(color: AppColors.textHint)))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => _AdminOrderCard(
                      order: filtered[i],
                      onStatusChange: (s) => _changeStatus(context, filtered[i], s),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _changeStatus(BuildContext context, OrderModel order, OrderStatus newStatus) async {
    await context.read<OrderProvider>().updateStatus(order.id, newStatus);
    context.read<AdminProvider>().refreshStats();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Order updated to ${newStatus.name}'),
        backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating,
      ));
    }
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
          color: isActive ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? AppColors.accent : AppColors.border),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
          color: isActive ? Colors.white : AppColors.textSecondary)),
      ),
    ),
  );
}

class _AdminOrderCard extends StatelessWidget {
  final OrderModel order;
  final Function(OrderStatus) onStatusChange;
  const _AdminOrderCard({required this.order, required this.onStatusChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(order.userName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            Text(order.userEmail, style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
            Text('ID: ${order.id}', style: const TextStyle(fontSize: 10, color: AppColors.textHint, fontFamily: 'monospace')),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: _color(order.status).withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
              child: Text(order.statusLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _color(order.status))),
            ),
            const SizedBox(height: 4),
            Text(AppFormatters.currency(order.totalAmount),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
          ]),
        ]),
        const SizedBox(height: 10),
        const Divider(height: 1, color: AppColors.divider),
        const SizedBox(height: 10),
        // Items list
        ...order.items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(item.productImage, width: 36, height: 36, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(width: 36, height: 36, color: AppColors.tagBg)),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.productName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text('by ${item.weaverName} · qty: ${item.quantity}${item.selectedColor != null ? " · ${item.selectedColor}" : ""}',
                style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
            ])),
            Text(AppFormatters.currency(item.totalPrice), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ]),
        )),
        const SizedBox(height: 8),
        Text('Ordered ${AppFormatters.date(order.orderDate)}', style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
        const SizedBox(height: 10),
        // Status pipeline
        Row(children: [
          const Text('Update:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(width: 6),
          ...OrderStatus.values.map((s) => Padding(
            padding: const EdgeInsets.only(right: 4),
            child: GestureDetector(
              onTap: s != order.status ? () => onStatusChange(s) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: s == order.status ? _color(s) : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _color(s).withOpacity(0.4)),
                ),
                child: Text(_shortLabel(s), style: TextStyle(
                  fontSize: 9, fontWeight: FontWeight.w700,
                  color: s == order.status ? Colors.white : _color(s))),
              ),
            ),
          )),
        ]),
      ]),
    );
  }

  String _shortLabel(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending: return 'PND';
      case OrderStatus.processing: return 'WVN';
      case OrderStatus.shipped: return 'SHP';
      case OrderStatus.delivered: return 'DLV';
      case OrderStatus.cancelled: return 'CXL';
    }
  }

  Color _color(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending: return AppColors.warning;
      case OrderStatus.processing: return const Color(0xFF1565C0);
      case OrderStatus.shipped: return AppColors.primary;
      case OrderStatus.delivered: return AppColors.success;
      case OrderStatus.cancelled: return AppColors.error;
    }
  }
}
