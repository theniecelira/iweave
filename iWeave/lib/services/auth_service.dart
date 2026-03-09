import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _keyLoggedIn = 'isLoggedIn';
  static const String _keyUserId = 'userId';
  static const String _keyUserName = 'userName';
  static const String _keyUserEmail = 'userEmail';

  // Mock accounts
  static const _mockAccounts = <String, Map<String, String>>{
    'tourist@iweave.ph': {'password': 'tourist123', 'name': 'Maria Santos', 'id': 'u1'},
    'weaver@iweave.ph': {'password': 'weaver123', 'name': 'Nanay Rosa', 'id': 'u2'},
    'admin@iweave.ph': {'password': 'admin123', 'name': 'Admin User', 'id': 'u3'},
    'demo@demo.com': {'password': 'demo123', 'name': 'Demo User', 'id': 'u4'},
  };

  Future<UserModel?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final account = _mockAccounts[email.toLowerCase()];
    if (account == null || account['password'] != password) {
      throw Exception('Invalid email or password');
    }
    final user = UserModel(
      id: account['id'] as String, name: account['name'] as String,
      email: email.toLowerCase(), createdAt: DateTime.now(),
    );
    await _saveSession(user);
    return user;
  }

  Future<UserModel> signup(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (_mockAccounts.containsKey(email.toLowerCase())) {
      throw Exception('An account with this email already exists');
    }
    final user = UserModel(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      name: name, email: email.toLowerCase(),
      createdAt: DateTime.now(),
    );
    await _saveSession(user);
    return user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
  }

  Future<UserModel?> getStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyLoggedIn) ?? false;
    if (!isLoggedIn) return null;
    return UserModel(
      id: prefs.getString(_keyUserId) ?? '',
      name: prefs.getString(_keyUserName) ?? '',
      email: prefs.getString(_keyUserEmail) ?? '',
      createdAt: DateTime.now(),
    );
  }

  Future<void> _saveSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyUserId, user.id);
    await prefs.setString(_keyUserName, user.name);
    await prefs.setString(_keyUserEmail, user.email);
  }

  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // Simulate sending reset email
  }
}
