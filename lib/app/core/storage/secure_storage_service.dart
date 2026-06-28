import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService() : _storage = const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const String _accessTokenKey = 'access_token';
  static const String _guestModeKey = 'guest_mode';

  Future<void> salvarToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
    await _storage.write(key: _guestModeKey, value: 'false');
  }

  Future<String?> obterToken() => _storage.read(key: _accessTokenKey);

  Future<void> salvarModoVisitante(bool enabled) {
    return _storage.write(key: _guestModeKey, value: enabled.toString());
  }

  Future<bool> obterModoVisitante() async {
    final value = await _storage.read(key: _guestModeKey);
    return value == 'true';
  }

  Future<void> limparSessao() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _guestModeKey);
  }
}
