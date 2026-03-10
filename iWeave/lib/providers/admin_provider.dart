import 'package:flutter/material.dart';
import '../services/database_service.dart';

class AdminProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  Map<String, dynamic> _stats = {};
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = false;

  Map<String, dynamic> get stats => _stats;
  List<Map<String, dynamic>> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> loadDashboard() async {
    _isLoading = true;
    notifyListeners();
    _stats = await _db.getAdminStats();
    _users = await _db.getUsers();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshStats() async {
    _stats = await _db.getAdminStats();
    notifyListeners();
  }
}
