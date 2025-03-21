import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:boybin/pages/home.dart';
import 'package:boybin/auth/auth_service.dart';
import 'package:boybin/auth/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check if the user is already logged in
  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (isLoggedIn) {
      // Navigate to the home screen if the user is already logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  // Handle login logic
  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Example API endpoint
    const String apiUrl = "https://pay1.jetdev.life/api/account/login";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': email, 'password': password}),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        // Parse response data
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Create user data object
        final userData = UserData(
          userName: responseData['userName'] ?? '',
          email: responseData['email'] ?? '',
          profileImageUrl: responseData['profileImageUrl'] ?? '',
          token: responseData['token'] ?? '',
        );

        // Save user data
        await AuthService.saveUserData(userData);

        // Save login state
        await _saveLoginState();

        // Navigate to the home screen on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Show an error message if login fails
        final errorMessage = jsonDecode(response.body)['message'] ?? 'Login failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  // Save login state to shared preferences
  Future<void> _saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Green gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF00C853), // Lighter green at top
              Color(0xFF009624), // Darker green at bottom
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // User icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 50,
                        color: Color(0xFF00C853),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Log In! text
                    const Text(
                      'Log In!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Sign in to your account text
                    const Text(
                      'Sign In to your account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Email field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.white70),
                          prefixIcon: Icon(Icons.email_outlined, color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Forgot password
                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          text: 'Forgot your ',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'password?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('Forgot password tapped');
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Login button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                              ),
                            )
                          : const Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 24),

                    // Don't have an account
                    RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Create',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}