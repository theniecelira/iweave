import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../data/mock_data.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;

  List<ProductModel> get products => _filteredProducts;
  List<ProductModel> get featuredProducts => _products.where((p) => p.isFeatured).toList();
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  static const List<String> categories = ['All', 'Bags', 'Mats', 'Cases', 'Wallets', 'Slippers'];

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    _products = List.from(mockProducts);
    _isLoading = false;
    notifyListeners();
  }

  List<ProductModel> get _filteredProducts {
    return _products.where((p) {
      final matchCat = _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
  }

  void setCategory(String cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleFavorite(String productId) {
    final idx = _products.indexWhere((p) => p.id == productId);
    if (idx != -1) {
      _products[idx].isFavorite = !_products[idx].isFavorite;
      notifyListeners();
    }
  }

  ProductModel? getById(String id) => _products.firstWhere((p) => p.id == id, orElse: () => _products.first);
}
