import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService() : _storage = const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<void> salvarToken(String token) =>
      _storage.write(key: 'access_token', value: token);

  Future<String?> obterToken() => _storage.read(key: 'access_token');

  Future<void> limparSessao() => _storage.deleteAll();
}
