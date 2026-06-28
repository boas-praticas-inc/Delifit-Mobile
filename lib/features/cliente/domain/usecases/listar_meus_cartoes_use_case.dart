import '../entities/cartao_cliente.dart';
import '../repositories/cliente_repository.dart';

class ListarMeusCartoesUseCase {
  const ListarMeusCartoesUseCase(this.repository);

  final ClienteRepository repository;

  Future<List<CartaoCliente>> call() => repository.listarMeusCartoes();
}

