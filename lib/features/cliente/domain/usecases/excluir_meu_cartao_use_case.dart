import '../repositories/cliente_repository.dart';

class ExcluirMeuCartaoUseCase {
  const ExcluirMeuCartaoUseCase(this.repository);

  final ClienteRepository repository;

  Future<void> call(int cartaoId) => repository.excluirMeuCartao(cartaoId);
}

