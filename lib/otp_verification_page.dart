import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pinput/pinput.dart';
import 'pending_approval_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String verificationId;
  final String name;
  final String phoneNumber;
  final File? photo;
  final File? idProof;

  const OtpVerificationPage({
    Key? key,
    required this.verificationId,
    required this.name,
    required this.phoneNumber,
    this.photo,
    this.idProof,
  }) : super(key: key);

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  Future<void> _verifyOtpAndRegister(String smsCode) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );

      // Sign the user in (or link) with the credential
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // --- User is verified, now upload files and save data ---
        String? photoUrl;
        String? idProofUrl;

        // Upload photo if it exists
        if (widget.photo != null) {
          final photoRef = FirebaseStorage.instance
              .ref()
              .child('worker_photos')
              .child('${user.uid}.jpg');
          await photoRef.putFile(widget.photo!);
          photoUrl = await photoRef.getDownloadURL();
        }

        // Upload ID proof if it exists
        if (widget.idProof != null) {
          final idProofRef = FirebaseStorage.instance
              .ref()
              .child('worker_id_proofs')
              .child('${user.uid}.jpg');
          await idProofRef.putFile(widget.idProof!);
          idProofUrl = await idProofRef.getDownloadURL();
        }

        // Save worker data to Firestore
        await FirebaseFirestore.instance.collection('workers').doc(user.uid).set({
          'name': widget.name,
          'phoneNumber': widget.phoneNumber,
          'photoUrl': photoUrl,
          'idProofUrl': idProofUrl,
          'status': 'pending',
          'role': 'worker',
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Navigate to the pending approval page
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const PendingApprovalPage()),
              (Route<dynamic> route) => false,
        );

      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify OTP: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text('OTP Verification'),
        backgroundColor: const Color(0xFF0066B3),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter Verification Code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002B4A),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Enter the 6-digit code sent to\n${widget.phoneNumber}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              Pinput(
                length: 6,
                controller: _otpController,
                focusNode: _otpFocusNode,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: const Color(0xFF0066B3)),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Colors.green),
                  ),
                ),
                onCompleted: (pin) {
                  _verifyOtpAndRegister(pin);
                },
              ),
              const SizedBox(height: 40),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_otpController.text.length == 6) {
                      _verifyOtpAndRegister(_otpController.text);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter the complete 6-digit OTP.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066B3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'VERIFY & REGISTER',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // TODO: Implement resend OTP logic if needed
                },
                child: const Text(
                  'Resend Code',
                  style: TextStyle(color: Color(0xFF0066B3)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
