import '../models/user.dart';

// The contract for the Authentication Liaison Agent.
abstract class AuthRepository {
  Future<void> requestOtp(String phoneNumber);
  Future<({User user, String token})> verifyOtp(String phoneNumber, String otp);
}