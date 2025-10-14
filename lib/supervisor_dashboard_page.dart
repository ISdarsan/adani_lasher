import 'package:flutter/material.dart';

class SupervisorDashboardPage extends StatelessWidget {
  const SupervisorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervisor Dashboard'),
      ),
      body: const Center(
        child: Text(
          'Welcome, Supervisor!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
