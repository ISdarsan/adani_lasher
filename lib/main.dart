import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'firebase_options.dart'; // Import the generated config file
import 'splash_page.dart';
import 'login_page.dart';
import 'registration_page.dart';
import 'pending_approval_page.dart';
import 'access_denied_page.dart';
import 'role_splash_page.dart';
import 'admin_dashboard_page.dart';
import 'supervisor_dashboard_page.dart';
import 'worker_dashboard_page.dart';
import 'approve_workers_page.dart';
import 'worker_details_page.dart';

void main() async { // Make main an async function
  // Ensure that Flutter is initialized before we run the app
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lasher Adani',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/pending_approval': (context) => const PendingApprovalPage(),
        '/access_denied': (context) => const AccessDeniedPage(),
        '/approve_workers': (context) => const ApproveWorkersPage(),
        '/lasher/admin': (context) => const AdminDashboardPage(),
        '/lasher/supervisor': (context) => const SupervisorDashboardPage(),
        '/lasher/worker': (context) => const WorkerDashboardPage(),
        // Note: RoleSplashPage and WorkerDetailsPage are navigated to directly,
        // but importing them here ensures the project is fully aware of them.
      },
    );
  }
}

