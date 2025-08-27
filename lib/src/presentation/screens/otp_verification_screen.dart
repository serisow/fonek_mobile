import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/controllers/auth_controller.dart';
import '../../domain/providers.dart';

// This screen is also a "dumb" UI Liaison Agent.
// It translates the user's OTP input and button press into a single
// command for our Decider (AuthController).
class OtpVerificationScreen extends ConsumerWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpController = TextEditingController();
    
    // We observe the AuthController state to know when to show a loading indicator.
    final authState = ref.watch(authControllerProvider);

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
              'Enter the 6-digit code sent to $phoneNumber',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
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
                      // The UI gives a simple, clean command to the Decider.
                      // The Decider will handle all the complex orchestration:
                      // - calling the repository
                      // - saving the token
                      // - updating the global authentication state
                      ref.read(authControllerProvider.notifier).verifyOtp(
                            phoneNumber,
                            otpController.text.trim(),
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