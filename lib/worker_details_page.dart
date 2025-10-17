import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:intl/intl.dart';

class WorkerDetailsPage extends StatelessWidget {
  // Accept the worker's data map and their unique document ID
  final Map<String, dynamic> workerData;
  final String workerId;

  const WorkerDetailsPage({
    super.key,
    required this.workerData,
    required this.workerId,
  });

  // Function to calculate age from Date of Birth string (dd/MM/yyyy)
  String _calculateAge(String? dobString) {
    if (dobString == null) return 'N/A';
    try {
      final dob = DateFormat('dd/MM/yyyy').parse(dobString);
      final today = DateTime.now();
      int age = today.year - dob.year;
      if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
        age--;
      }
      return age.toString();
    } catch (e) {
      return 'N/A'; // Return 'Not Available' if the date format is wrong
    }
  }

  // --- Functions to handle Approval and Rejection ---

  // Function to update worker status in Firestore
  Future<void> _updateWorkerStatus(BuildContext context, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('workers')
          .doc(workerId)
          .update({'status': newStatus});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Worker has been ${newStatus == 'approved' ? 'Approved' : 'Rejected'}.'),
          backgroundColor: newStatus == 'approved' ? Colors.green : Colors.red,
        ),
      );
      // Go back to the previous screen after action
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    // Reusable gradient for a consistent brand look
    final LinearGradient adaniGradient = const LinearGradient(
      colors: [
        Color(0xFF0066B3), // Blue
        Color(0xFF6C3FB5), // Purple
        Color(0xFFE91E63), // Pink
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    // Safely access data with null checks
    final String name = workerData['name'] ?? 'No Name';
    final String phone = workerData['phoneNumber'] ?? 'No Phone Number';
    final String dob = workerData['dateOfBirth'] ?? 'N/A';
    final String photoUrl = workerData['photoUrl'] ?? 'https://placehold.co/100x100/EFEFEF/333333?text=NA';
    final String idUrl = workerData['idProofUrl'] ?? 'https://placehold.co/600x400/EFEFEF/333333?text=ID+Proof+NA';


    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: adaniGradient),
          ),
          title: const Text(
            'Worker Details',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 3,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(photoUrl),
                backgroundColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailCard(
              title: 'Personal Information',
              details: {
                'Phone Number': phone,
                'Date of Birth': dob,
                'Age': _calculateAge(dob),
              },
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'ID Proof',
              isImage: true,
              imageUrl: idUrl,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cancel_outlined, color: Colors.white),
                label: const Text('Reject', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  // Call the backend function to set status to 'rejected'
                  _updateWorkerStatus(context, 'rejected');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                label: const Text('Approve', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  // Call the backend function to set status to 'approved'
                  _updateWorkerStatus(context, 'approved');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build the detail cards
  Widget _buildDetailCard({
    required String title,
    Map<String, String>? details,
    bool isImage = false,
    String? imageUrl,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0066B3),
              ),
            ),
            const Divider(height: 20),
            if (isImage && imageUrl != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    height: 200,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 50, color: Colors.red),
                  ),
                ),
              )
            else if (details != null)
              ...details.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key, style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                    Text(entry.value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }
}
