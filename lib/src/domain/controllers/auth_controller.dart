import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/secure_storage_repository.dart';

// State Tablet for our authentication state.
enum AuthStatus { authenticated, unauthenticated, loading, initial, error, awaitingOtp } 

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final String? phoneNumberForVerification;

  // [CORRECTION] Add the new field to the constructor.
  AuthState({
    required this.status,
    this.user,
    this.errorMessage,
    this.phoneNumberForVerification,
  });
}


class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepo;
  final SecureStorageRepository _storageRepo;

  AuthController(this._authRepo, this._storageRepo) 
      : super(AuthState(status: AuthStatus.initial));

  // Orchestration method to handle OTP verification.
  Future<void> verifyOtp(String phoneNumber, String otp) async {
    state = AuthState(status: AuthStatus.loading);
    try {
      final result = await _authRepo.verifyOtp(phoneNumber, otp);
      await _storageRepo.saveToken(result.token);
      state = AuthState(status: AuthStatus.authenticated, user: result.user);
    } catch (e) {
      state = AuthState(status: AuthStatus.error, errorMessage: e.toString());
      Future.delayed(const Duration(milliseconds: 100), () {
        state = AuthState(status: AuthStatus.unauthenticated);
      });
    }
  }
  // Orchestration method to check if a user is already logged in.
  Future<void> checkAuthStatus() async {
    final token = await _storageRepo.readToken();
    if (token != null) {
      // In a real app, you would verify the token with the server
      // and fetch the user profile here. For MVP, we'll assume the token is valid.
      state = AuthState(status: AuthStatus.authenticated);
    } else {
      state = AuthState(status: AuthStatus.unauthenticated);
    }
  }

  // Orchestration method for signing out.
  Future<void> signOut() async {
    await _storageRepo.deleteToken();
    state = AuthState(status: AuthStatus.unauthenticated);
  }

  void setPhoneNumberForVerification(String phoneNumber) {
    state = AuthState(status: AuthStatus.awaitingOtp, phoneNumberForVerification: phoneNumber);
  }
}