import '../repositories/auth_repository.dart';

class EntrarComoVisitanteUseCase {
  const EntrarComoVisitanteUseCase(this.repository);

  final AuthRepository repository;

  Future<void> call() {
    return repository.entrarComoVisitante();
  }
}

