import '../repositories/auth_repository.dart';

class SairUseCase {
  const SairUseCase(this.repository);

  final AuthRepository repository;

  Future<void> call() {
    return repository.sair();
  }
}

