import 'package:flutter/material.dart';
import '../models/tour_model.dart';
import '../data/mock_data.dart';

enum BookTab { tours, hotels, restaurants, transport, flights }

class TourProvider extends ChangeNotifier {
  List<TourModel> _tours = [];
  List<AccommodationModel> _accommodations = [];
  List<RestaurantModel> _restaurants = [];
  TourCategory _selectedCategory = TourCategory.all;
  BookTab _activeTab = BookTab.tours;
  bool _isLoading = false;
  String _searchQuery = '';

  List<TourModel> get tours => _filteredTours;
  List<AccommodationModel> get accommodations => _accommodations;
  List<RestaurantModel> get restaurants => _restaurants;
  TourCategory get selectedCategory => _selectedCategory;
  BookTab get activeTab => _activeTab;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    _tours = List.from(mockTours);
    _accommodations = List.from(mockAccommodations);
    _restaurants = List.from(mockRestaurants);
    _isLoading = false;
    notifyListeners();
  }

  List<TourModel> get _filteredTours {
    return _tours.where((t) {
      final matchCat = _selectedCategory == TourCategory.all || t.category == _selectedCategory;
      final matchSearch = _searchQuery.isEmpty ||
          t.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
  }

  void setCategory(TourCategory cat) { _selectedCategory = cat; notifyListeners(); }
  void setTab(BookTab tab) { _activeTab = tab; notifyListeners(); }
  void setSearch(String q) { _searchQuery = q; notifyListeners(); }

  void toggleTourFavorite(String id) {
    final idx = _tours.indexWhere((t) => t.id == id);
    if (idx != -1) { _tours[idx].isFavorite = !_tours[idx].isFavorite; notifyListeners(); }
  }

  TourModel? getTourById(String id) => _tours.firstWhere((t) => t.id == id, orElse: () => _tours.first);
}
