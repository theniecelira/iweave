import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/formatters.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/common/app_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? _selectedMaterial;
  String? _selectedColor;
  String? _selectedDesign;
  bool _giftWrap = false;
  final _giftMsgCtrl = TextEditingController();
  final _giftFromCtrl = TextEditingController();
  final _giftToCtrl = TextEditingController();
  int _currentImage = 0;

  @override
  void dispose() {
    _giftMsgCtrl.dispose(); _giftFromCtrl.dispose(); _giftToCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = context.read<ProductProvider>().getById(widget.productId);
    if (product == null) return const Scaffold(body: Center(child: Text('Product not found')));

    _selectedMaterial ??= product.availableMaterials.first;
    _selectedColor ??= product.availableColors.first;
    _selectedDesign ??= product.availableDesigns.first;

    final images = [product.imageUrl, ...product.additionalImages];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300, pinned: true,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                onPressed: () => context.read<ProductProvider>().toggleFavorite(product.id),
                icon: Icon(
                  product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: product.isFavorite ? Colors.white : Colors.white70,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/cart'),
                icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    itemCount: images.length,
                    onPageChanged: (i) => setState(() => _currentImage = i),
                    itemBuilder: (_, i) => Image.network(
                      images[i], fit: BoxFit.cover, width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(color: AppColors.tagBg,
                        child: const Icon(Icons.image_not_supported, size: 64, color: AppColors.textHint)),
                    ),
                  ),
                  if (images.length > 1)
                    Positioned(
                      bottom: 12, left: 0, right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(images.length, (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: i == _currentImage ? 16 : 6, height: 6,
                          decoration: BoxDecoration(
                            color: i == _currentImage ? Colors.white : Colors.white54,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        )),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                            const SizedBox(height: 4),
                            Row(children: [
                              const Icon(Icons.person_outline, size: 14, color: AppColors.textHint),
                              const SizedBox(width: 4),
                              Text('by ${product.weaverName}', style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                            ]),
                          ],
                        ),
                      ),
                      Text(AppFormatters.currency(product.basePrice),
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Icon(Icons.star_rounded, size: 16, color: AppColors.star),
                    const SizedBox(width: 4),
                    Text('${product.rating} · ${product.reviewCount} reviews',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 16),
                  Text(product.description, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6)),

                  if (product.isCustomizable) ...[
                    const SizedBox(height: 20),
                    const Divider(color: AppColors.divider),
                    const SizedBox(height: 16),

                    // Material
                    _buildOptionSection('Material:', product.availableMaterials, _selectedMaterial, (v) => setState(() => _selectedMaterial = v), isText: true),
                    const SizedBox(height: 16),

                    // Color
                    _buildColorSection(product.availableColors),
                    const SizedBox(height: 16),

                    // Design
                    _buildOptionSection('Preferred design:', product.availableDesigns, _selectedDesign, (v) => setState(() => _selectedDesign = v), isText: true),
                    const SizedBox(height: 16),

                    // Gift Wrap
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(color: _giftWrap ? AppColors.primary : AppColors.border),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        color: _giftWrap ? AppColors.tagBg : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Checkbox(
                              value: _giftWrap,
                              onChanged: (v) => setState(() => _giftWrap = v ?? false),
                              activeColor: AppColors.primary,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            const Expanded(
                              child: Row(children: [
                                Icon(Icons.card_giftcard_rounded, size: 16, color: AppColors.primary),
                                SizedBox(width: 6),
                                Text('Gift wrap this item?', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                SizedBox(width: 6),
                                Text('Regular wrapping paper: ₱25.00', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                              ]),
                            ),
                          ]),
                          if (_giftWrap) ...[
                            const SizedBox(height: 10),
                            Row(children: [
                              Expanded(child: TextField(
                                controller: _giftToCtrl,
                                decoration: const InputDecoration(labelText: 'To:', hintText: 'Name of Receiver', isDense: true),
                              )),
                              const SizedBox(width: 10),
                              Expanded(child: TextField(
                                controller: _giftFromCtrl,
                                decoration: const InputDecoration(labelText: 'From:', hintText: 'Name of Sender', isDense: true),
                              )),
                            ]),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _giftMsgCtrl,
                              decoration: const InputDecoration(hintText: 'Write a message...', isDense: true),
                              maxLines: 2,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                  Row(children: [
                    Expanded(child: AppButton(
                      label: 'Add to Cart', isOutlined: true,
                      icon: const Icon(Icons.shopping_bag_outlined, size: 18, color: AppColors.primary),
                      onPressed: () => _addToCart(context, product),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: AppButton(
                      label: 'Order Now',
                      onPressed: () { _addToCart(context, product); Navigator.pushNamed(context, '/cart'); },
                    )),
                  ]),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionSection(String label, List<String> options, String? selected, Function(String) onSelect, {bool isText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: options.map((opt) {
            final isSelected = selected == opt;
            return GestureDetector(
              onTap: () => onSelect(opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                  border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                ),
                child: Text(opt, style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                )),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  final _colorMap = {
    'Natural': Color(0xFFF5E6C8), 'Red': Colors.red, 'Green': Colors.green,
    'Blue': Colors.blue, 'Yellow': Colors.amber, 'Purple': Colors.purple,
    'Teal': Colors.teal, 'Orange': Colors.orange, 'Pink': Colors.pink,
  };

  Widget _buildColorSection(List<String> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Text('Preferred color:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Text(_selectedColor ?? '', style: const TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600)),
          const Icon(Icons.expand_more, size: 16, color: AppColors.primary),
        ]),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10, runSpacing: 8,
          children: colors.map((c) {
            final isSelected = _selectedColor == c;
            final color = _colorMap[c] ?? AppColors.primary;
            return GestureDetector(
              onTap: () => setState(() => _selectedColor = c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: color, shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 2.5,
                  ),
                  boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)] : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _addToCart(BuildContext context, ProductModel product) {
    context.read<CartProvider>().addItem(
      product,
      material: _selectedMaterial, color: _selectedColor, design: _selectedDesign,
      giftWrap: _giftWrap,
      giftMessage: _giftMsgCtrl.text.isEmpty ? null : _giftMsgCtrl.text,
      giftFrom: _giftFromCtrl.text.isEmpty ? null : _giftFromCtrl.text,
      giftTo: _giftToCtrl.text.isEmpty ? null : _giftToCtrl.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text('${product.name} added to cart'),
        ]),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'View Cart', textColor: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
      ),
    );
  }
}
