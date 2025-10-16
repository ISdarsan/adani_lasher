import 'package:flutter/material.dart';
import 'worker_details_page.dart'; // Import the details page

class ApproveWorkersPage extends StatelessWidget {
  const ApproveWorkersPage({super.key});

  // Dummy data for pending applications. This will later come from Firebase.
  final List<Map<String, String>> pendingWorkers = const [
    {'name': 'Arjun Kumar', 'phone': '+91 9876543210', 'photoUrl': 'https://placehold.co/100x100/EFEFEF/333333?text=AK', 'dob': '15/05/1995', 'idUrl': 'https://placehold.co/600x400/EFEFEF/333333?text=ID+Proof'},
    {'name': 'Priya Sharma', 'phone': '+91 9123456789', 'photoUrl': 'https://placehold.co/100x100/EFEFEF/333333?text=PS', 'dob': '22/08/1998', 'idUrl': 'https://placehold.co/600x400/EFEFEF/333333?text=ID+Proof'},
    {'name': 'Ravi Shankar', 'phone': '+91 8765432109', 'photoUrl': 'https://placehold.co/100x100/EFEFEF/333333?text=RS', 'dob': '01/12/1990', 'idUrl': 'https://placehold.co/600x400/EFEFEF/333333?text=ID+Proof'},
  ];

  @override
  Widget build(BuildContext context) {
    // Reusable gradient for a consistent brand look
    const LinearGradient adaniGradient = LinearGradient(
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
            decoration: const BoxDecoration(gradient: adaniGradient),
          ),
          title: const Text(
            'Pending Approvals',
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: pendingWorkers.length,
        itemBuilder: (context, index) {
          final worker = pendingWorkers[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                // Navigate to the detail page, passing the worker's data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkerDetailsPage(worker: worker),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(worker['photoUrl']!),
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            worker['name']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            worker['phone']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Arrow icon to indicate that the item is tappable
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}