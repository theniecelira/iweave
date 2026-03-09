import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get count => _items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get shippingFee => _items.isEmpty ? 0.0 : 150.0;
  double get total => subtotal + shippingFee;

  void addItem(ProductModel product, {
    String? material, String? color, String? design,
    bool giftWrap = false, String? giftMessage, String? giftFrom, String? giftTo,
  }) {
    final existing = _items.firstWhere(
      (i) => i.product.id == product.id && i.selectedMaterial == material &&
             i.selectedColor == color && i.selectedDesign == design,
      orElse: () => CartItem(product: product),
    );
    if (_items.contains(existing)) {
      existing.quantity++;
    } else {
      _items.add(CartItem(
        product: product, quantity: 1,
        selectedMaterial: material, selectedColor: color, selectedDesign: design,
        giftWrap: giftWrap, giftMessage: giftMessage, giftFrom: giftFrom, giftTo: giftTo,
      ));
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void updateQuantity(int index, int qty) {
    if (qty <= 0) {
      removeItem(index);
      return;
    }
    _items[index].quantity = qty;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
