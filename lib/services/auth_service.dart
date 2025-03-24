import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:boybin/models/user_model.dart';
import 'package:boybin/models/activity_model.dart';
import 'package:boybin/services/storage_service.dart';

class AuthService {
  final StorageService _storageService = StorageService();
  final String baseUrl = "https://pay1.jetdev.life/api";

  // Login user
  Future<User> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/account/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        final user = User(
          id: responseData['id'] ?? '',
          userName: responseData['userName'] ?? '',
          email: responseData['email'] ?? '',
          profileImageUrl: responseData['profileImageUrl'] ?? '',
          token: responseData['token'] ?? '',
        );
        
        // Save user data and token
        await _storageService.saveUser(user);
        
        return user;
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
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
      final response = await http.post(
        Uri.parse('$baseUrl/account/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'profileImageUrl': profileImageUrl,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        
        final user = User(
          id: responseData['id'] ?? '',
          userName: responseData['userName'] ?? '',
          email: responseData['email'] ?? '',
          profileImageUrl: responseData['profileImageUrl'] ?? '',
          token: responseData['token'] ?? '',
        );
        
        // Save user data and token
        await _storageService.saveUser(user);
        
        return user;
      } else {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Registration error: $e');
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
  }

  Future<List<Activity>> fetchActivities({int limit = 20}) async {
    final token = await _storageService.getToken(); // Retrieve token
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/account/activity?limit=$limit'),
      headers: {'Authorization': 'Bearer $token'}, // Use token
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Activity.fromJson(json)).toList();
    }
    return [];
    }
}