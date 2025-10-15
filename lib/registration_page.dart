import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: adaniGradient),
          ),
          title: const Text(
            'New Worker Registration',
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _buildTextField(controller: _nameController, label: 'Full Name', icon: Icons.person_outline),
            const SizedBox(height: 16),
            _buildTextField(controller: _phoneController, label: 'Phone Number', icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 24),
            _buildFileUploadButton(context, title: 'Upload Your Photo', icon: Icons.camera_alt_outlined),
            const SizedBox(height: 16),
            _buildFileUploadButton(context, title: 'Upload ID Proof', icon: Icons.badge_outlined),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: const Color(0xFF0066B3),
              ),
              onPressed: () {
                // TODO: Implement logic to save data to Firebase
                // For now, navigate to the pending approval page
                Navigator.pushReplacementNamed(context, '/pending_approval');
              },
              child: const Text(
                'Submit for Approval',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }

  Widget _buildFileUploadButton(BuildContext context, {required String title, required IconData icon}) {
    return OutlinedButton.icon(
      icon: Icon(icon, color: Colors.grey[700]),
      label: Text(
        title,
        style: TextStyle(color: Colors.grey[700], fontSize: 16),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        side: BorderSide(color: Colors.grey[400]!),
      ),
      onPressed: () {
        // TODO: Implement file picking logic
      },
    );
  }
}

