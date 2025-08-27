import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/controllers/auth_controller.dart';
import '../../domain/providers.dart';
import 'home_screen.dart';
import 'phone_auth_screen.dart';
import 'otp_verification_screen.dart'; 

// This widget acts as a gatekeeper for the entire application.
// Its sole purpose is to observe the authentication state and display
// the appropriate screen.
class AuthWidget extends ConsumerStatefulWidget {
  const AuthWidget({super.key});

  @override
  ConsumerState<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends ConsumerState<AuthWidget> {
  // This method is called exactly once when the widget is first created.
  // It's the perfect place to give the initial command to our system.
  @override
  void initState() {
    super.initState();
    // We command our AuthController (the Decider) to check the user's
    // authentication status as soon as the app starts.
    // 'ref.read' is used here because we only need to trigger the action once,
    // not listen for continuous changes in this specific spot.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authControllerProvider.notifier).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    // We observe ('watch') the state from our Decider (AuthController).
    // Whenever this state changes, this widget will automatically rebuild.
    final authState = ref.watch(authControllerProvider);

    // This switch is declarative. It describes what to show for each state,
    // but contains no complex logic itself.
    switch (authState.status) {
      case AuthStatus.authenticated:
        return const HomeScreen();
      case AuthStatus.unauthenticated:
      case AuthStatus.error: 
        return const PhoneAuthScreen();
      case AuthStatus.awaitingOtp:
        return OtpVerificationScreen(
          phoneNumber: authState.phoneNumberForVerification!,
        );
      case AuthStatus.loading:
      case AuthStatus.initial:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
    }
  }
}