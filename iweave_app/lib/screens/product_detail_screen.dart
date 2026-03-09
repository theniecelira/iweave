import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/product.dart';
import '../widgets/info_pill.dart';
import 'design_studio_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Image.network(
            product.imageUrl,
            height: 320,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 320,
              color: AppColors.border,
              child: const Icon(Icons.image_not_supported_outlined),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.category,
                  style: const TextStyle(color: AppColors.mutedText),
                ),
                const SizedBox(height: 6),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '₱${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  product.description,
                  style: const TextStyle(height: 1.5),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    const InfoPill(icon: Icons.handyman_rounded, label: 'Handcrafted'),
                    InfoPill(
                      icon: Icons.auto_awesome_rounded,
                      label: product.customizable ? 'Customizable' : 'Ready-made',
                    ),
                    const InfoPill(icon: Icons.sell_rounded, label: 'Local artisan'),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Available palette',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: product.palettes
                      .map(
                        (palette) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(palette),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Saved to wishlist')),
                          );
                        },
                        child: const Text('Save'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (product.customizable) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DesignStudioScreen(
                                  selectedProductName: product.name,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Mock added to cart')),
                            );
                          }
                        },
                        child: Text(
                          product.customizable ? 'Customize' : 'Add to cart',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}