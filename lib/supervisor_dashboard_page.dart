import 'package:flutter/material.dart';
import 'approve_workers_page.dart'; // Import the page that was missing

// TODO: Import the other pages for each feature when they are created
// import 'my_team_page.dart';
// import 'notifications_history_page.dart';
// import 'settings_page.dart';

class SupervisorDashboardPage extends StatelessWidget {
  const SupervisorDashboardPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: adaniGradient),
          ),
          title: const Text(
            'Supervisor Dashboard',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 3,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(gradient: adaniGradient),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.supervisor_account, size: 40, color: Colors.blue),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Supervisor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.group_outlined, color: Colors.blue),
              title: const Text('My Team'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to the My Team page
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_none, color: Colors.blue),
              title: const Text('Notifications History'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to the Notifications History page
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined, color: Colors.blue),
              title: const Text('Generate Weekly Report'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement report generation logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: Colors.blue),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to the Settings page
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () {
                // TODO: Add Logout Splash Page navigation
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      // The body of the dashboard
      body: Column(
        children: [
          _buildStatsHeader(),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildDashboardTile(
                  context,
                  icon: Icons.how_to_reg_outlined,
                  title: 'Approve Workers',
                  onTap: () {
                    // Navigate to the page for approving new workers
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ApproveWorkersPage()),
                    );
                  },
                ),
                _buildDashboardTile(
                  context,
                  icon: Icons.assignment_ind_outlined,
                  title: 'Assign Work',
                  onTap: () {},
                ),
                _buildDashboardTile(
                  context,
                  icon: Icons.checklist_rtl_outlined,
                  title: 'View Attendance',
                  onTap: () {},
                ),
                _buildDashboardTile(
                  context,
                  icon: Icons.assignment_turned_in_outlined,
                  title: 'Review Tasks',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _StatItem(count: '12', label: 'Active Workers'),
          _StatItem(count: '3', label: 'Pending Approvals'),
        ],
      ),
    );
  }

  Widget _buildDashboardTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: const Color(0xFF0066B3)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0066B3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  const _StatItem({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0066B3),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

