import 'package:flutter/material.dart';

class WorkerDashboardPage extends StatelessWidget {
  const WorkerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Dashboard'),
      ),
      body: const Center(
        child: Text(
          'Welcome, Worker!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
