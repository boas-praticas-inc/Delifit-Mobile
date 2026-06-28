import '../entities/cliente_perfil.dart';
import '../repositories/cliente_repository.dart';

class AtualizarMeuPerfilUseCase {
  const AtualizarMeuPerfilUseCase(this.repository);

  final ClienteRepository repository;

  Future<ClientePerfil> call({
    required String nomeCompleto,
    required String cpf,
    required String telefone,
    required DateTime? dataNascimento,
  }) {
    return repository.atualizarMeuPerfil(
      nomeCompleto: nomeCompleto,
      cpf: cpf,
      telefone: telefone,
      dataNascimento: dataNascimento,
    );
  }
}

