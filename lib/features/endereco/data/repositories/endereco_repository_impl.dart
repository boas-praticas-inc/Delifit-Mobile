import '../../../../app/core/errors/app_exception.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../domain/entities/endereco.dart';
import '../../domain/repositories/endereco_repository.dart';
import '../datasources/endereco_remote_data_source.dart';
import '../models/criar_endereco_request_model.dart';

class EnderecoRepositoryImpl implements EnderecoRepository {
  const EnderecoRepositoryImpl({
    required this.authLocalDataSource,
    required this.remoteDataSource,
  });

  final AuthLocalDataSource authLocalDataSource;
  final EnderecoRemoteDataSource remoteDataSource;

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
    final token = await authLocalDataSource.obterToken();
    if (token == null || token.isEmpty) {
      throw const AppException('Sessão inválida. Faça login novamente.');
    }

    return remoteDataSource.criarMeuEndereco(
      token: token,
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
}


