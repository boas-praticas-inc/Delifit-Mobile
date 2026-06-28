import '../entities/sessao_usuario.dart';

abstract class AuthRepository {
  Future<SessaoUsuario> entrarComTelefone({
    required String telefone,
    required String senha,
  });

  Future<SessaoUsuario> registrarCliente({
    required String telefone,
    required String senha,
    required String nomeCompleto,
    required String cpf,
    required DateTime? dataNascimento,
  });

  Future<SessaoUsuario?> obterSessaoAtual();

  Future<void> entrarComoVisitante();

  Future<bool> obterModoVisitante();

  Future<void> sair();
}
