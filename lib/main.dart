import 'package:flutter/material.dart';
import 'package:lasher_adani/admin_dashboard_page.dart';
import 'package:lasher_adani/login_page.dart';
import 'package:lasher_adani/registration_page.dart';
import 'package:lasher_adani/splash_page.dart';
import 'package:lasher_adani/supervisor_dashboard_page.dart';
import 'package:lasher_adani/worker_dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hides the debug banner in the top-right corner
      debugShowCheckedModeBanner: false,
      title: 'Lasher Adani',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // The initial route that the app will start on.
      initialRoute: '/',
      // Defines the available named routes and the widgets to build when navigating to those routes.
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/lasher/admin': (context) => const AdminDashboardPage(),
        '/lasher/supervisor': (context) => const SupervisorDashboardPage(),
        '/lasher/worker': (context) => const WorkerDashboardPage(),
      },
    );
  }
}

