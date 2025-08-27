import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/auth_repository.dart';
import 'otp_verification_screen.dart'; 

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  // Local state for the UI: controller for the text field and loading state.
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  // Storing the prefix as a constant for clarity and reusability.
  static const String _phonePrefix = '+33';

  // This method is a "UI Artisan". Its job is to command the Decider.
  Future<void> _requestOtp() async {
    if (_phoneController.text.isEmpty) {
      print("Phone number is empty");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authRepo = context.read<AuthRepository>();
      final String fullPhoneNumber = '$_phonePrefix${_phoneController.text.trim()}';
      
      await authRepo.requestOtp(fullPhoneNumber);

      print("OTP requested successfully! Navigating to OTP screen.");

      // [MODIFICATION] On success, navigate to the OTP screen,
      // passing the full phone number as a parameter.
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(phoneNumber: fullPhoneNumber),
          ),
        );
      }

    }  catch (e) {
      print("Error requesting OTP: $e");
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                // The prefix text is for display purposes only.
                prefixText: '$_phonePrefix ', 
              ),
              keyboardType: TextInputType.phone,
              // Optional: improve UX by automatically moving cursor
              autofocus: true, 
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _requestOtp,
                    child: const Text('Continue'),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed.
    _phoneController.dispose();
    super.dispose();
  }
}