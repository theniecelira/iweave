import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../widgets/category_chip.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final products = selectedCategory == 'All'
        ? MockDataService.products
        : MockDataService.products
            .where((p) =>
                p.category == selectedCategory || selectedCategory == 'Custom')
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Banig Products')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: CustomSearchBar(hint: 'Search woven products'),
          ),
          SizedBox(
            height: 46,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: MockDataService.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = MockDataService.categories[index];
                return CategoryChip(
                  label: category,
                  selected: selectedCategory == category,
                  onTap: () {
                    setState(() => selectedCategory = category);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 245,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}