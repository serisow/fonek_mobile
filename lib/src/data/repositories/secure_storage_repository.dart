import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Contract for our Secure Storage Liaison Agent.
abstract class SecureStorageRepository {
  Future<void> saveToken(String token);
  Future<String?> readToken();
  Future<void> deleteToken();
}

// Concrete implementation of the Liaison Agent.
class SecureStorageRepositoryImpl implements SecureStorageRepository {
  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  @override
  Future<void> saveToken(String token) {
    return _storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> readToken() {
    return _storage.read(key: _tokenKey);
  }

  @override
  Future<void> deleteToken() {
    return _storage.delete(key: _tokenKey);
  }
}