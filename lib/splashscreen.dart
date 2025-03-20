// import 'package:boybin/pages/Home.dart';
// import 'package:boybinnew/pages/home.dart';
import 'package:boybin/auth/login.dart';
// import 'package:boybin/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
// Removed duplicate import as 'package:boybin/pages/Home.dart' already exists
// import 'package:page_transition/page_transition.dart'; // Import for PageTransitionType

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
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
            // Text(' Splash Screen',style: TextStyle(color: Colors.white, fontSize: 28),),
            Image.asset(
              'assets/images/splash2.png', // Replace with your image path
              width: 300, // Adjust the width as needed
              height: 300, // Adjust the height as needed
            ),
            // style
          ],
        ),
      ),
    );
  }
}
