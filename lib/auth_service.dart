import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});
}

class AuthService with ChangeNotifier {
  final Client client;
  late Account account;

  bool _isLoggedIn = false;
  User? _currentUser;

  bool get isLoggedIn => _isLoggedIn;
  User? get currentUser => _currentUser;

  AuthService(this.client) {
    account = Account(client);
    init();
  }

  Future<void> init() async {
    try {
      final user = await account.get();
      _isLoggedIn = true;
      _currentUser = User(id: user.$id, name: user.name, email: user.email);
    } on AppwriteException {
      _isLoggedIn = false;
      _currentUser = null;
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    await account.createEmailPasswordSession(email: email, password: password);
    final user = await account.get();
    _isLoggedIn = true;
    _currentUser = User(id: user.$id, name: user.name, email: user.email);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', true);
    await prefs.setString('email', email);

    notifyListeners();
  }

  Future<void> signOut() async {
    await account.deleteSession(sessionId: 'current');
    _isLoggedIn = false;
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  Future<User?> signUp(String name, String email, String password) async {
    try {
      // Create the user account
      await account.create(userId: ID.unique(), name: name, email: email, password: password);
      
      // Immediately log the user in to create a session
      await login(email, password);
      return _currentUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> getCurrentUser() async {
    return _currentUser;
  }
}
