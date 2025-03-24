import 'package:boybin/bloc/user_bloc.dart';
import 'package:boybin/controllers/auth_controller.dart';
import 'package:boybin/view/home_screen.dart';
import 'package:boybin/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Check if user is logged in
    final isLoggedIn = await _authController.isLoggedIn();
    
    if (isLoggedIn) {
      // Get user data
      final user = await _authController.getCurrentUser();
      
      if (user != null) {
        // Update the BLoC with the user data
        context.read<UserBloc>().add(SetUserEvent(user));
      }
    }
    
    // Wait for 5 seconds
    await Future.delayed(const Duration(seconds: 5));
    
    // Navigate to appropriate screen
    if (mounted) {
      if (isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF127E16), // #127E16
              Color(0xFF16DD69), // #16DD69
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash2.png', // Replace with your image path
              width: 300, // Adjust the width as needed
              height: 300, // Adjust the height as needed
            ),
          ],
        ),
      ),
    );
  }
}