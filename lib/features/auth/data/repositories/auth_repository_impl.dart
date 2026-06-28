import '../../domain/entities/sessao_usuario.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/registro_cliente_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<SessaoUsuario> entrarComTelefone({
    required String telefone,
    required String senha,
  }) async {
    final response = await remoteDataSource.loginCliente(
      telefone: telefone,
      senha: senha,
    );
    final cliente = await remoteDataSource.obterMeuPerfilCliente(response.accessToken);

    await localDataSource.salvarToken(response.accessToken);
    await localDataSource.salvarModoVisitante(false);

    return SessaoUsuario(
      accessToken: response.accessToken,
      usuarioId: response.usuario.id,
      telefone: response.usuario.telefone,
      tipoUsuario: response.usuario.tipoUsuario,
      nomeCompleto: cliente.nomeCompleto,
    );
  }

  @override
  Future<SessaoUsuario> registrarCliente({
    required String telefone,
    required String senha,
    required String nomeCompleto,
    required String cpf,
    required DateTime? dataNascimento,
  }) async {
    final response = await remoteDataSource.registrarCliente(
      RegistroClienteRequestModel(
        telefone: telefone,
        senha: senha,
        nomeCompleto: nomeCompleto,
        cpf: cpf,
        dataNascimento: dataNascimento,
      ),
    );

    await localDataSource.salvarToken(response.accessToken);
    await localDataSource.salvarModoVisitante(false);

    return SessaoUsuario(
      accessToken: response.accessToken,
      usuarioId: response.usuario.id,
      telefone: response.usuario.telefone,
      tipoUsuario: response.usuario.tipoUsuario,
      nomeCompleto: response.cliente.nomeCompleto,
    );
  }

  @override
  Future<SessaoUsuario?> obterSessaoAtual() async {
    final token = await localDataSource.obterToken();
    if (token == null || token.isEmpty) {
      return null;
    }

    try {
      final usuario = await remoteDataSource.obterUsuarioAutenticado(token);
      final cliente = await remoteDataSource.obterMeuPerfilCliente(token);

      return SessaoUsuario(
        accessToken: token,
        usuarioId: usuario.id,
        telefone: usuario.telefone,
        tipoUsuario: usuario.tipoUsuario,
        nomeCompleto: cliente.nomeCompleto,
      );
    } catch (_) {
      await localDataSource.limparSessao();
      return null;
    }
  }

  @override
  Future<void> entrarComoVisitante() async {
    await localDataSource.limparSessao();
    await localDataSource.salvarModoVisitante(true);
  }

  @override
  Future<bool> obterModoVisitante() {
    return localDataSource.obterModoVisitante();
  }

  @override
  Future<void> sair() {
    return localDataSource.limparSessao();
  }
}

