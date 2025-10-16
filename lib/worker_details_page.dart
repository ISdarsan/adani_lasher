import 'package:flutter/material.dart';

class WorkerDetailsPage extends StatelessWidget {
  // We will pass the specific worker's data to this page
  final Map<String, String> worker;

  const WorkerDetailsPage({super.key, required this.worker});

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
                backgroundImage: NetworkImage(worker['photoUrl']!),
                backgroundColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                worker['name']!,
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
                'Phone Number': worker['phone']!,
                'Date of Birth': worker['dob']!,
              },
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'ID Proof',
              isImage: true,
              imageUrl: worker['idUrl']!,
            ),
          ],
        ),
      ),
      // Floating action buttons for approve/reject
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Reject'),
                onPressed: () {
                  // TODO: Implement reject logic
                  Navigator.pop(context); // Go back to the list
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Approve'),
                onPressed: () {
                  // TODO: Implement approve logic
                  Navigator.pop(context); // Go back to the list
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
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

