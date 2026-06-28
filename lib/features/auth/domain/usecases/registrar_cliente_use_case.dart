import '../entities/sessao_usuario.dart';
import '../repositories/auth_repository.dart';

class RegistrarClienteUseCase {
  const RegistrarClienteUseCase(this.repository);

  final AuthRepository repository;

  Future<SessaoUsuario> call({
    required String telefone,
    required String senha,
    required String nomeCompleto,
    required String cpf,
    required DateTime? dataNascimento,
  }) {
    return repository.registrarCliente(
      telefone: telefone,
      senha: senha,
      nomeCompleto: nomeCompleto,
      cpf: cpf,
      dataNascimento: dataNascimento,
    );
  }
}
