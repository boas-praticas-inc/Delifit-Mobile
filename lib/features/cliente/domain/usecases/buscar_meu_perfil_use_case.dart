import '../entities/cliente_perfil.dart';
import '../repositories/cliente_repository.dart';

class BuscarMeuPerfilUseCase {
  const BuscarMeuPerfilUseCase(this.repository);

  final ClienteRepository repository;

  Future<ClientePerfil> call() => repository.buscarMeuPerfil();
}

