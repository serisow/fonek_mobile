import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers.dart';
import 'otp_verification_screen.dart';

// [CORRECTION] It must be a ConsumerStatefulWidget to manage its own state (controller, loading).
class PhoneAuthScreen extends ConsumerStatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  ConsumerState<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends ConsumerState<PhoneAuthScreen> {
  // The controller is now part of the State, so it persists across rebuilds.
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  static const String _phonePrefix = '+33';

  Future<void> _requestOtp() async {
    if (_phoneController.text.trim().isEmpty) {
      // In a real app, show a snackbar for user feedback.
      debugPrint("Phone number is empty");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authRepo = ref.read(authRepositoryProvider);
      // The full phone number is now correctly constructed.
      final fullPhoneNumber = '$_phonePrefix${_phoneController.text.trim()}';

      await authRepo.requestOtp(fullPhoneNumber);

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(phoneNumber: fullPhoneNumber),
        ),
      );
    } catch (e) {
      debugPrint("Error requesting OTP: $e");
      // TODO: Show user-facing error message.
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // It's crucial to dispose of the controller.
    _phoneController.dispose();
    super.dispose();
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixText: '$_phonePrefix ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              autofocus: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _requestOtp,
                    child: const Text('Continue'),
                  ),
          ],
        ),
      ),
    );
  }
}