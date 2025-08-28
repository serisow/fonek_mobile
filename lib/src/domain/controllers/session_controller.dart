import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/session.dart';
import '../../data/repositories/session_repository.dart';

// The State Tablet for the session feature.
class SessionState {
  final Session? activeSession;
  final bool isLoading;
  // We'll add more state properties here later (other user position, etc.)
  SessionState({this.activeSession, this.isLoading = false});
}

// The SessionController: our "Decider" Artisan for sessions.
class SessionController extends StateNotifier<SessionState> {
  final SessionRepository _sessionRepo;
  SessionController(this._sessionRepo) : super(SessionState());

  // Orchestration method to handle session creation.
  Future<void> createSession({
    required String recipientPhone,
    required int durationInMinutes,
  }) async {
    state = SessionState(isLoading: true);
    try {
      final newSession = await _sessionRepo.createSession(
      recipientPhone: recipientPhone,
      durationInMinutes: durationInMinutes,
      );
      state = SessionState(activeSession: newSession, isLoading: false);
      // TODO: Navigate to a "waiting for recipient" screen.
    } catch (e) {
      state = SessionState(isLoading: false);
      // TODO: Handle error state properly.
    }   
  }
}