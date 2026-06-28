import '../../../endereco/domain/entities/endereco.dart';
import '../repositories/cliente_repository.dart';

class ListarMeusEnderecosUseCase {
  const ListarMeusEnderecosUseCase(this.repository);

  final ClienteRepository repository;

  Future<List<Endereco>> call() => repository.listarMeusEnderecos();
}

