import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/controllers/auth_controller.dart';
import '../../domain/providers.dart';

//It must be a ConsumerStatefulWidget to manage its controller.
class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  // The controller is now part of the State and will persist.
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    // We listen for state changes to show one-time events like errors.
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'An unknown error occurred.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    


    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter the 6-digit code sent to ${widget.phoneNumber}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(
                labelText: 'OTP Code',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 12),
            ),
            const SizedBox(height: 20),
            authState.status == AuthStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      final otp = _otpController.text.trim();                      
                      ref.read(authControllerProvider.notifier).verifyOtp(
                            widget.phoneNumber,
                            otp,
                          );
                    },
                    child: const Text('Verify'),
                  ),
          ],
        ),
      ),
    );
  }
}
