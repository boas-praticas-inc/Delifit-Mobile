import '../repositories/cliente_repository.dart';

class ExcluirMeuEnderecoUseCase {
  const ExcluirMeuEnderecoUseCase(this.repository);

  final ClienteRepository repository;

  Future<void> call(int enderecoId) => repository.excluirMeuEndereco(enderecoId);
}

