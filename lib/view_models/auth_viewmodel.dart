import 'package:flutter/material.dart';
import '../data/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final _authService = AuthService();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<String?> registerUser(String email, String password, String name, String role) async {
    _setLoading(true);
    try {
      await _authService.signUp(email, password, name, role);
      _setLoading(false);
      return null; 
    } catch (e) {
      _setLoading(false);
      return e.toString(); 
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners(); 
  }// Handles logging in across the architecture layers
  Future<String?> loginUser(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.signIn(email, password);
      _setLoading(false);
      return null; // Return null if login credentials match perfectly
    } catch (e) {
      _setLoading(false);
      return e.toString(); // Return human-readable text error from Firebase
    }
  }

}