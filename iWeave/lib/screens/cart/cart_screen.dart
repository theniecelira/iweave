import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/formatters.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/loading_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Consumer<CartProvider>(
          builder: (_, cart, __) => Text('Cart (${cart.count} items)'),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (_, cart, __) => cart.items.isNotEmpty
              ? TextButton(
                  onPressed: () => _confirmClear(context, cart),
                  child: const Text('Clear', style: TextStyle(color: AppColors.error, fontSize: 13)),
                )
              : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (_, cart, __) {
          if (cart.items.isEmpty) {
            return EmptyStateWidget(
              title: 'Your cart is empty',
              subtitle: 'Add some beautiful banig products to get started',
              icon: Icons.shopping_bag_outlined,
              actionLabel: 'Browse Products',
              onAction: () => Navigator.pushNamed(context, '/products'),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final item = cart.items[i];
                    return _CartItemCard(
                      item: item,
                      onIncrease: () => cart.updateQuantity(i, item.quantity + 1),
                      onDecrease: () => cart.updateQuantity(i, item.quantity - 1),
                      onRemove: () => cart.removeItem(i),
                    );
                  },
                ),
              ),
              _OrderSummary(cart: cart),
            ],
          );
        },
      ),
    );
  }

  void _confirmClear(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Remove all items from your cart?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () { cart.clear(); Navigator.pop(context); },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onIncrease, onDecrease, onRemove;
  const _CartItemCard({required this.item, required this.onIncrease, required this.onDecrease, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            child: Image.network(
              item.product.imageUrl, width: 80, height: 80, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(width: 80, height: 80, color: AppColors.tagBg),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                if (item.selectedColor != null || item.selectedMaterial != null)
                  Text(
                    [if (item.selectedMaterial != null) item.selectedMaterial, if (item.selectedColor != null) item.selectedColor].join(' · '),
                    style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                  ),
                if (item.giftWrap) const Text('🎁 Gift wrapped', style: TextStyle(fontSize: 11, color: AppColors.accent)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(AppFormatters.currency(item.totalPrice),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    const Spacer(),
                    _QtyButton(icon: Icons.remove, onTap: onDecrease),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('${item.quantity}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                    _QtyButton(icon: Icons.add, onTap: onIncrease),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(icon, size: 16, color: AppColors.textPrimary),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final CartProvider cart;
  const _OrderSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, -4))],
      ),
      child: Column(
        children: [
          _Row('Subtotal', AppFormatters.currency(cart.subtotal)),
          const SizedBox(height: 6),
          _Row('Shipping Fee', AppFormatters.currency(cart.shippingFee)),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(color: AppColors.divider)),
          _Row('Total', AppFormatters.currency(cart.total), isBold: true),
          const SizedBox(height: 16),
          AppButton(
            label: 'Proceed to Checkout',
            icon: const Icon(Icons.lock_outline_rounded, size: 18, color: Colors.white),
            onPressed: () => _showCheckoutSuccess(context),
          ),
        ],
      ),
    );
  }

  void _showCheckoutSuccess(BuildContext context) {
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
              child: const Icon(Icons.check_circle_rounded, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text('Order Placed!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text(
              'Your order has been received. Your artisan weaver will start crafting your product. Estimated delivery: 7-14 business days.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'Continue Shopping',
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false).clear();
                Navigator.of(context).pop(); // close dialog
                Navigator.pushReplacementNamed(context, '/main', arguments: 0);
              },
            )
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  const _Row(this.label, this.value, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: isBold ? 16 : 14,
      fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
      color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label, style: style), Text(value, style: style.copyWith(color: isBold ? AppColors.primary : null))],
    );
  }
}
