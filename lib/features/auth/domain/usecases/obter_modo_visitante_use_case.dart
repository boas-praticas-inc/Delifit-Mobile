import '../repositories/auth_repository.dart';

class ObterModoVisitanteUseCase {
  const ObterModoVisitanteUseCase(this.repository);

  final AuthRepository repository;

  Future<bool> call() {
    return repository.obterModoVisitante();
  }
}
