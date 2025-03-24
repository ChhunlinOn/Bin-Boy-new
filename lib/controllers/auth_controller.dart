import 'package:boybin/models/user_model.dart';
import 'package:boybin/services/auth_service.dart';
import 'package:boybin/services/storage_service.dart';

class AuthController {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  // Login user
  Future<User> login(String email, String password) async {
    try {
      // Use the auth service to login
      final user = await _authService.login(email, password);
      
      // Store the token and user data
      await _storageService.saveToken(user.token);
      await _storageService.saveUser(user);
      
      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Register user
  Future<User> register(
    String username, 
    String email, 
    String password, 
    String profileImageUrl
  ) async {
    try {
      // Use the auth service to register
      final user = await _authService.register(username, email, password, profileImageUrl);
      
      // Store the token and user data
      await _storageService.saveToken(user.token);
      await _storageService.saveUser(user);
      
      return user;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _storageService.isLoggedIn();
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    return await _storageService.getUser();
  }

  // Logout
  Future<void> logout() async {
    await _storageService.clearUser();
    await _storageService.clearToken();
  }
}