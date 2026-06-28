import '../entities/sessao_usuario.dart';
import '../repositories/auth_repository.dart';

class EntrarComTelefoneUseCase {
  const EntrarComTelefoneUseCase(this.repository);

  final AuthRepository repository;

  Future<SessaoUsuario> call({
    required String telefone,
    required String senha,
  }) {
    return repository.entrarComTelefone(telefone: telefone, senha: senha);
  }
}
