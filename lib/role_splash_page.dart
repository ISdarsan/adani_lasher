import 'dart:async';
import 'package:flutter/material.dart';

class RoleSplashPage extends StatefulWidget {
  final String role; // This will be 'Admin', 'Supervisor', or 'Worker'

  const RoleSplashPage({super.key, required this.role});

  @override
  State<RoleSplashPage> createState() => _RoleSplashPageState();
}

class _RoleSplashPageState extends State<RoleSplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Animation for the logo to "pop" in
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    // Animation for the text and spinner to fade in
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    );

    _controller.forward();

    // After 3 seconds, navigate to the correct dashboard
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      String routeName;
      switch (widget.role.toLowerCase()) {
        case 'admin':
          routeName = '/lasher/admin';
          break;
        case 'supervisor':
          routeName = '/lasher/supervisor';
          break;
        case 'worker':
          routeName = '/lasher/worker';
          break;
        default:
          routeName = '/login'; // Fallback to login
      }
      Navigator.pushReplacementNamed(context, routeName);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            // Animated Logo
            ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                'assets/LOGO.png',
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 25),
            // Animated Welcome Text and Spinner
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => blueGradient.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: Text(
                      'Welcome ${widget.role}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
