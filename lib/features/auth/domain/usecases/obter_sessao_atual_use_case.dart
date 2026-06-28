import '../entities/sessao_usuario.dart';
import '../repositories/auth_repository.dart';

class ObterSessaoAtualUseCase {
  const ObterSessaoAtualUseCase(this.repository);

  final AuthRepository repository;

  Future<SessaoUsuario?> call() {
    return repository.obterSessaoAtual();
  }
}

