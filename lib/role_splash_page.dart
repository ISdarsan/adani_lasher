import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import all necessary pages for navigation
import 'admin_dashboard_page.dart';
import 'supervisor_dashboard_page.dart';
import 'worker_dashboard_page.dart';
import 'pending_approval_page.dart';
import 'access_denied_page.dart';
import 'login_page.dart';


class RoleSplashPage extends StatefulWidget {
  const RoleSplashPage({super.key});

  @override
  State<RoleSplashPage> createState() => _RoleSplashPageState();
}

class _RoleSplashPageState extends State<RoleSplashPage> {

  @override
  void initState() {
    super.initState();
    // Start the navigation logic as soon as the page loads
    _checkUserRoleAndNavigate();
  }

  Future<void> _checkUserRoleAndNavigate() async {
    // Give the animation a moment to be appreciated
    await Future.delayed(const Duration(seconds: 2));

    User? user = FirebaseAuth.instance.currentUser;

    // If for some reason there is no user, go to login screen
    if (user == null) {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      }
      return;
    }

    // --- HANDLE DEMO LOGINS ---
    // Check for special demo accounts first
    if (user.email == 'admin@demo.com') {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDashboardPage()));
      return;
    }
    if (user.email == 'supervisor@demo.com') {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SupervisorDashboardPage()));
      return;
    }
    if (user.email == 'worker@demo.com') {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WorkerDashboardPage()));
      return;
    }

    // --- HANDLE REAL USERS FROM FIRESTORE ---
    try {
      // Fetch the user's document from the 'workers' collection using their UID
      final docSnapshot = await FirebaseFirestore.instance.collection('workers').doc(user.uid).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        final status = data['status'] as String?;
        final role = data['role'] as String?;

        if (!mounted) return; // Check if the widget is still in the tree

        // First, check the approval status
        switch (status) {
          case 'pending':
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PendingApprovalPage()));
            break;
          case 'rejected':
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AccessDeniedPage()));
            break;
          case 'approved':
          // If approved, now check the role
            switch (role) {
              case 'worker':
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WorkerDashboardPage()));
                break;
              case 'supervisor':
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SupervisorDashboardPage()));
                break;
            // Admin role might be handled differently, but we can add it here
              case 'admin':
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDashboardPage()));
                break;
              default:
              // If role is unknown, send to access denied
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AccessDeniedPage()));
            }
            break;
          default:
          // If status is unknown, send to access denied
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AccessDeniedPage()));
        }
      } else {
        // If no document found for this user, they might be an admin without a worker profile
        // Or it's an error. For now, let's send them to the login page.
        if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    } catch (e) {
      // Handle potential errors (e.g., network issues)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error checking user role: $e')),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0066B3), Color(0xFF6C3FB5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/neon_ring.json', // Your cool animation
                width: 250,
                height: 250,
              ),
              const SizedBox(height: 20),
              const Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
