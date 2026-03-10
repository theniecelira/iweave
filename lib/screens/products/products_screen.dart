import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../providers/product_provider.dart';
import '../../widgets/cards/product_card.dart';
import '../../widgets/common/loading_widget.dart';

class ProductsScreen extends StatefulWidget {
  final String? initialCategory;
  const ProductsScreen({super.key, this.initialCategory});
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ProductProvider>().setCategory(widget.initialCategory!);
      });
    }
  }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Shop Banig Products'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: provider.setSearch,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
                suffixIcon: _searchCtrl.text.isNotEmpty
                  ? IconButton(
                      onPressed: () { _searchCtrl.clear(); provider.setSearch(''); },
                      icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textHint),
                    )
                  : null,
                filled: true, fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Category tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: ProductProvider.categories.map((cat) {
                final isSelected = provider.selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => provider.setCategory(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                        boxShadow: isSelected ? [] : [BoxShadow(color: AppColors.shadow, blurRadius: 4)],
                      ),
                      child: Text(cat,
                        style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        )),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: provider.isLoading
              ? const LoadingWidget(message: 'Loading products...')
              : provider.products.isEmpty
                ? EmptyStateWidget(
                    title: 'No products found',
                    subtitle: 'Try a different category or search term',
                    icon: Icons.shopping_bag_outlined,
                    actionLabel: 'Clear Filters',
                    onAction: () { provider.setCategory('All'); _searchCtrl.clear(); provider.setSearch(''); },
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 12,
                      mainAxisSpacing: 12, childAspectRatio: 0.72,
                    ),
                    itemCount: provider.products.length,
                    itemBuilder: (_, i) {
                      final p = provider.products[i];
                      return ProductCard(
                        product: p,
                        onTap: () => Navigator.pushNamed(context, '/product-detail', arguments: p.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
