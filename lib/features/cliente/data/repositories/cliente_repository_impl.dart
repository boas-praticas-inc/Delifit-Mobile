import '../../../../app/core/errors/app_exception.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../../endereco/data/models/criar_endereco_request_model.dart';
import '../../../endereco/domain/entities/endereco.dart';
import '../../domain/entities/cartao_cliente.dart';
import '../../domain/entities/cliente_perfil.dart';
import '../../domain/repositories/cliente_repository.dart';
import '../datasources/cliente_remote_data_source.dart';

class ClienteRepositoryImpl implements ClienteRepository {
  const ClienteRepositoryImpl({
    required this.authLocalDataSource,
    required this.remoteDataSource,
  });

  final AuthLocalDataSource authLocalDataSource;
  final ClienteRemoteDataSource remoteDataSource;

  Future<String> _token() async {
    final token = await authLocalDataSource.obterToken();
    if (token == null || token.isEmpty) {
      throw const AppException('Sessão inválida. Faça login novamente.');
    }
    return token;
  }

  @override
  Future<ClientePerfil> buscarMeuPerfil() async {
    return remoteDataSource.buscarMeuPerfil(await _token());
  }

  @override
  Future<ClientePerfil> atualizarMeuPerfil({
    required String nomeCompleto,
    required String cpf,
    required String telefone,
    required DateTime? dataNascimento,
  }) async {
    return remoteDataSource.atualizarMeuPerfil(
      token: await _token(),
      nomeCompleto: nomeCompleto,
      cpf: cpf,
      telefone: telefone,
      dataNascimento: dataNascimento,
    );
  }

  @override
  Future<List<Endereco>> listarMeusEnderecos() async {
    return remoteDataSource.listarMeusEnderecos(await _token());
  }

  @override
  Future<Endereco> criarMeuEndereco({
    required String cep,
    required String logradouro,
    required String numero,
    required String bairro,
    required String cidade,
    required String estado,
    String? complemento,
    String? referencia,
    String? label,
  }) async {
    return remoteDataSource.criarMeuEndereco(
      token: await _token(),
      payload: CriarEnderecoRequestModel(
        cep: cep,
        logradouro: logradouro,
        numero: numero,
        bairro: bairro,
        cidade: cidade,
        estado: estado,
        complemento: complemento,
        referencia: referencia,
        label: label,
      ),
    );
  }

  @override
  Future<Endereco> atualizarMeuEndereco({
    required int enderecoId,
    required String cep,
    required String logradouro,
    required String numero,
    required String bairro,
    required String cidade,
    required String estado,
    String? complemento,
    String? referencia,
    String? label,
  }) async {
    return remoteDataSource.atualizarMeuEndereco(
      token: await _token(),
      enderecoId: enderecoId,
      payload: CriarEnderecoRequestModel(
        cep: cep,
        logradouro: logradouro,
        numero: numero,
        bairro: bairro,
        cidade: cidade,
        estado: estado,
        complemento: complemento,
        referencia: referencia,
        label: label,
      ),
    );
  }

  @override
  Future<void> excluirMeuEndereco(int enderecoId) async {
    await remoteDataSource.excluirMeuEndereco(
      token: await _token(),
      enderecoId: enderecoId,
    );
  }

  @override
  Future<List<CartaoCliente>> listarMeusCartoes() async {
    return remoteDataSource.listarMeusCartoes(await _token());
  }

  @override
  Future<CartaoCliente> criarMeuCartao({
    required String nomeTitular,
    required String ultimosQuatroDigitos,
    required String bandeira,
    required bool padrao,
    String? tokenGateway,
  }) async {
    return remoteDataSource.criarMeuCartao(
      token: await _token(),
      nomeTitular: nomeTitular,
      ultimosQuatroDigitos: ultimosQuatroDigitos,
      bandeira: bandeira,
      padrao: padrao,
      tokenGateway: tokenGateway,
    );
  }

  @override
  Future<CartaoCliente> atualizarMeuCartao({
    required int cartaoId,
    required String nomeTitular,
    required String ultimosQuatroDigitos,
    required String bandeira,
    required bool padrao,
    String? tokenGateway,
  }) async {
    return remoteDataSource.atualizarMeuCartao(
      token: await _token(),
      cartaoId: cartaoId,
      nomeTitular: nomeTitular,
      ultimosQuatroDigitos: ultimosQuatroDigitos,
      bandeira: bandeira,
      padrao: padrao,
      tokenGateway: tokenGateway,
    );
  }

  @override
  Future<void> excluirMeuCartao(int cartaoId) async {
    await remoteDataSource.excluirMeuCartao(
      token: await _token(),
      cartaoId: cartaoId,
    );
  }
}


