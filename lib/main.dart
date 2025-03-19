// import 'package:boybin/splashscreen.dart';
// import 'package:boybinnew/pages/home.dart';
// import 'package:boybinnew/splashscreen.dart';
// import 'package:boybinnew/splashscreen.dart';
import 'package:boybin/splashscreen.dart';
import 'package:flutter/material.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:lottie/lottie.dart';
// import 'pages/home.dart'; // Make sure this file exists

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Inter'),
      home: Splashscreen(), // Show SplashScreen first
    );
  }
}