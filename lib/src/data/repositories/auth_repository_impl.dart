import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import 'auth_repository.dart';

// The concrete implementation of our Liaison Agent.
class AuthRepositoryImpl implements AuthRepository {
  // '!' means we are certain API_BASE_URL is provided in the .env file.
  final String _baseUrl = dotenv.env['API_BASE_URL']!;
  @override
  Future<void> requestOtp(String phoneNumber) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/otp/request'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phone_number': phoneNumber}),
    );

    if (response.statusCode != 202) {
      // Simple error handling to start with.
      throw Exception('Failed to request OTP');
    }
  }

  @override
  Future<({User user, String token})> verifyOtp(String phoneNumber, String otp) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/otp/verify'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phone_number': phoneNumber, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      final user = User.fromJson(data['user']);
      final token = data['auth_token'] as String;

      return (
        user: user,
        token: token,
      );
    } else {
      throw Exception('Failed to verify OTP');
    }
  }
}
