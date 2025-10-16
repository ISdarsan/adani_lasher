import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _submitRegistration() {
    // Validate the form before submitting
    if (_formKey.currentState!.validate()) {
      // TODO: Connect to Firebase to save user data with 'pending' status
      // This is where you would save name, phone, dob, and hashed password.
      Navigator.pushReplacementNamed(context, '/pending_approval');
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildTextFormField(
                controller: _nameController,
                labelText: 'Full Name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _phoneController,
                labelText: 'Phone Number (this will be your login ID)',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: _inputDecoration('Date of Birth', Icons.calendar_today_outlined),
                validator: (value) => value!.isEmpty ? 'Please select your date of birth' : null,
              ),
              const SizedBox(height: 16),
              _buildPasswordFormField(
                controller: _passwordController,
                labelText: 'Password',
                isObscure: _obscurePassword,
                toggleVisibility: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: _inputDecoration('Confirm Password', Icons.lock_outline).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () {
                      setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                    },
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              _buildUploadButton(
                context,
                label: 'Upload Your Photo',
                icon: Icons.camera_alt_outlined,
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              _buildUploadButton(
                context,
                label: 'Upload ID Proof',
                icon: Icons.badge_outlined,
                onPressed: () {},
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: _submitRegistration,
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: adaniGradient,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      'Submit for Approval',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(labelText, icon),
      validator: (value) => value!.isEmpty ? 'This field is mandatory' : null,
    );
  }

  Widget _buildPasswordFormField({
    required TextEditingController controller,
    required String labelText,
    required bool isObscure,
    required VoidCallback toggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      decoration: _inputDecoration(labelText, Icons.lock_outline).copyWith(
        suffixIcon: IconButton(
          icon: Icon(isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
          onPressed: toggleVisibility,
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'This field is mandatory';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    );
  }

  Widget _buildUploadButton(
      BuildContext context, {
        required String label,
        required IconData icon,
        required VoidCallback onPressed,
      }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          foregroundColor: const Color(0xFF0066B3),
          side: const BorderSide(color: Color(0xFF0066B3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

