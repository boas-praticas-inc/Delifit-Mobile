import '../../../../app/core/storage/secure_storage_service.dart';

class AuthLocalDataSource {
  const AuthLocalDataSource(this.storageService);

  final SecureStorageService storageService;

  Future<void> salvarToken(String token) => storageService.salvarToken(token);

  Future<String?> obterToken() => storageService.obterToken();

  Future<void> salvarModoVisitante(bool enabled) =>
      storageService.salvarModoVisitante(enabled);

  Future<bool> obterModoVisitante() => storageService.obterModoVisitante();

  Future<void> limparSessao() => storageService.limparSessao();
}
