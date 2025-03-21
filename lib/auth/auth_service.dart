import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// User model to store authentication data
class UserData {
  final String userName;
  final String email;
  final String profileImageUrl;
  final String token;

  UserData({
    required this.userName,
    required this.email,
    required this.profileImageUrl,
    required this.token,
  });

  // Convert user data to JSON
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'token': token,
    };
  }

  // Create user data from JSON
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      token: json['token'] ?? '',
    );
  }
}

// Authentication service
class AuthService {
  static const String _userDataKey = 'user_data';

  // Save user data to shared preferences
  static Future<void> saveUserData(UserData userData) async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = jsonEncode(userData.toJson());
    await prefs.setString(_userDataKey, userDataJson);
  }

  // Get user data from shared preferences
  static Future<UserData?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString(_userDataKey);
    
    if (userDataJson == null) {
      return null;
    }
    
    try {
      final Map<String, dynamic> userData = jsonDecode(userDataJson);
      return UserData.fromJson(userData);
    } catch (e) {
      print('Error parsing user data: $e');
      return null;
    }
  }

  // Clear user data (logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDataKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final userData = await getUserData();
    return userData != null && userData.token.isNotEmpty;
  }
}