import '../models/session.dart';

// The contract for the Session Liaison Agent.
abstract class SessionRepository {
  Future<Session> createSession({
    required String recipientPhone,
    required int durationInMinutes,
  });
  
  // We'll add respondToSession and endSession later.
}