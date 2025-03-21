import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:boybin/pages/home.dart';
import 'package:boybin/auth/auth_service.dart';
import 'package:boybin/auth/login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  void _handleRegister() async {
    setState(() {
      _isLoading = true;
    });
    
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final imageUrl = _imageUrlController.text;

    // Validate passwords match
    if (password != confirmPassword) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // Example API endpoint for registration
    const String apiUrl = "https://pay1.jetdev.life/api/account/register";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'profileImageUrl': imageUrl,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
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
        
        // Navigate to the home screen on successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Show an error message if registration fails
        print('Registration failed: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${response.body}')),
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

  void _handleLogin() {
    // Navigate to login screen
    print('Login tapped');
    // Using pushReplacement to replace the current screen with the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _imageUrlController.dispose();
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
                        Icons.person_add_outlined,
                        size: 50,
                        color: Color(0xFF00C853),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Register text
                    const Text(
                      'Create Account!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Sign up text
                    const Text(
                      'Sign up to get started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Username field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: TextField(
                        controller: _usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Username',
                          hintStyle: TextStyle(color: Colors.white70),
                          prefixIcon: Icon(Icons.person_outline, color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
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
                    const SizedBox(height: 16),
                    
                    // Confirm Password field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: TextField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Image URL field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: TextField(
                        controller: _imageUrlController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Profile Image URL (optional)',
                          hintStyle: TextStyle(color: Colors.white70),
                          prefixIcon: Icon(Icons.image_outlined, color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Register button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegister,
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
                            'Create Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Already have an account
                    RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _handleLogin,
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