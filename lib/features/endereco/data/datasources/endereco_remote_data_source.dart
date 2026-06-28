import 'package:dio/dio.dart';

import '../../../../app/core/errors/app_exception.dart';
import '../../../../app/core/network/api_client.dart';
import '../../../../app/core/network/dio_error_mapper.dart';
import '../models/criar_endereco_request_model.dart';
import '../models/endereco_model.dart';

class EnderecoRemoteDataSource {
  const EnderecoRemoteDataSource(this.apiClient);

  final ApiClient apiClient;

  Future<EnderecoModel> criarMeuEndereco({
    required String token,
    required CriarEnderecoRequestModel payload,
  }) async {
    try {
      final response = await apiClient.dio.post<Map<String, dynamic>>(
        '/clientes/me/enderecos',
        data: payload.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return EnderecoModel.fromJson(response.data!);
    } on DioException catch (error) {
      throw AppException(mapearMensagemErro(error));
    }
  }
}

