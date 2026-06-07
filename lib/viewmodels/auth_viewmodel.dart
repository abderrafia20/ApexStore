import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  // Key used in SharedPreferences for session tracking
  static const String _sessionKey = 'user_session_email';

  // Check if a login session already exists
  Future<bool> checkLoginSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(_sessionKey);

      if (email != null) {
        // Retrieve full user profile from database
        final user = await _authRepository.getUserByEmail(email);
        if (user != null) {
          _currentUser = user;
          _isLoggedIn = true;
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to load session: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Register a new user
  Future<bool> register(String name, String email, String password, String confirmPassword) async {
    // 1. Validation checks
    if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _errorMessage = 'All fields are required.';
      notifyListeners();
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _errorMessage = 'Please enter a valid email address.';
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters.';
      notifyListeners();
      return false;
    }

    if (password != confirmPassword) {
      _errorMessage = 'Passwords do not match.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newUser = UserModel(
        name: name.trim(),
        email: email.trim().toLowerCase(),
        password: password,
      );

      await _authRepository.register(newUser);
      
      // Save session after successful registration
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sessionKey, newUser.email);

      _currentUser = newUser;
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Log in a user
  Future<bool> login(String email, String password) async {
    // 1. Validation checks
    if (email.trim().isEmpty || password.isEmpty) {
      _errorMessage = 'Email and password are required.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.login(email.trim().toLowerCase(), password);

      if (user != null) {
        // Save session after successful login
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_sessionKey, user.email);

        _currentUser = user;
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid email or password.';
      }
    } catch (e) {
      _errorMessage = 'Login failed: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Log out the user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_sessionKey);

      _currentUser = null;
      _isLoggedIn = false;
    } catch (e) {
      _errorMessage = 'Logout failed: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
