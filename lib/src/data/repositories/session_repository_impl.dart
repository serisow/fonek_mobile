import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/session.dart';
import 'secure_storage_repository.dart';
import 'session_repository.dart';

// Concrete implementation of the Session Liaison Agent.
class SessionRepositoryImpl implements SessionRepository {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;
  final SecureStorageRepository _storage;

  SessionRepositoryImpl({required SecureStorageRepository storage}) : _storage = storage;

  @override
  Future<Session> createSession({
    required String recipientPhone,
    required int durationInMinutes,
  }) async {
    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/sessions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'recipient_phone_number': recipientPhone,
        'duration_minutes': durationInMinutes,
      }),
    );

    if (response.statusCode == 201) {
      return Session.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create session: ${response.body}');
    }
  }
}