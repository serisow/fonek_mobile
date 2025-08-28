import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/secure_storage_repository.dart';
import '../data/repositories/session_repository.dart';
import '../data/repositories/session_repository_impl.dart';

import 'controllers/session_controller.dart';
import 'controllers/auth_controller.dart';

// This file is our central "tool catalog".

// --- DATA LAYER PROVIDERS (Liaison Agents) ---

final secureStorageProvider = Provider<SecureStorageRepository>((ref) {
  return SecureStorageRepositoryImpl();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  // SessionRepository needs SecureStorage to get the token.
  final storage = ref.watch(secureStorageProvider);
  return SessionRepositoryImpl(storage: storage);
});


// --- DOMAIN LAYER PROVIDERS (Deciders) ---

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  // A Decider gets its tools by watching other providers.
  final authRepo = ref.watch(authRepositoryProvider);
  final storageRepo = ref.watch(secureStorageProvider);
  return AuthController(authRepo, storageRepo);
});

final sessionControllerProvider =
    StateNotifierProvider<SessionController, SessionState>((ref) {
  final sessionRepo = ref.watch(sessionRepositoryProvider);
  return SessionController(sessionRepo);
});