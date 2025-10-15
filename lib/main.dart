import 'package:flutter/material.dart';
import 'splash_page.dart';
import 'login_page.dart';
import 'registration_page.dart';
import 'pending_approval_page.dart';
import 'role_splash_page.dart';
import 'admin_dashboard_page.dart';
import 'supervisor_dashboard_page.dart';
import 'worker_dashboard_page.dart';
import 'approve_workers_page.dart';

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
        '/pending_approval': (context) => const PendingApprovalPage(),
        // Note: RoleSplashPage is navigated to directly, not via a named route
        '/lasher/admin': (context) => const AdminDashboardPage(),
        '/lasher/supervisor': (context) => const SupervisorDashboardPage(),
        '/lasher/worker': (context) => const WorkerDashboardPage(),
        // Note: ApproveWorkersPage is also navigated to directly for now
      },
    );
  }
}

