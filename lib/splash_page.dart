import 'dart:async';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // After 3 seconds, navigate to the login page
    Timer(const Duration(seconds: 3), () {
      // Check if the widget is still in the tree before navigating
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define the gradient for the welcome text
    const Gradient blueGradient = LinearGradient(
      colors: [
        Color(0xFF003C8F), // Dark blue
        Color(0xFF2196F3), // Light blue
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your app logo
            Image.asset(
              'assets/LOGO.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 25),
            // "Welcome to Lasher" text with a gradient color
            ShaderMask(
              shaderCallback: (bounds) => blueGradient.createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: const Text(
                'Welcome to Lasher',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // This color is necessary for ShaderMask
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // A simple loading indicator
            const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Color(0xFF2196F3), // Matches the light blue in gradient
              ),
            ),
          ],
        ),
      ),
    );
  }
}
