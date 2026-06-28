import 'package:dio/dio.dart';

import '../../../../app/core/errors/app_exception.dart';
import '../../../../app/core/network/api_client.dart';
import '../../../../app/core/network/dio_error_mapper.dart';
import '../models/cliente_model.dart';
import '../models/login_response_model.dart';
import '../models/registro_cliente_request_model.dart';
import '../models/registro_cliente_response_model.dart';
import '../models/usuario_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this.apiClient);

  final ApiClient apiClient;

  Future<LoginResponseModel> loginCliente({
    required String telefone,
    required String senha,
  }) async {
    try {
      final response = await apiClient.dio.post<Map<String, dynamic>>(
        '/auth/clientes/login',
        data: {
          'telefone': telefone,
          'senha': senha,
        },
      );

      return LoginResponseModel.fromJson(response.data!);
    } on DioException catch (error) {
      throw AppException(mapearMensagemErro(error));
    }
  }

  Future<RegistroClienteResponseModel> registrarCliente(
    RegistroClienteRequestModel payload,
  ) async {
    try {
      final response = await apiClient.dio.post<Map<String, dynamic>>(
        '/auth/clientes/registro',
        data: payload.toJson(),
      );

      return RegistroClienteResponseModel.fromJson(response.data!);
    } on DioException catch (error) {
      throw AppException(mapearMensagemErro(error));
    }
  }

  Future<UsuarioModel> obterUsuarioAutenticado(String token) async {
    try {
      final response = await apiClient.dio.get<Map<String, dynamic>>(
        '/auth/me',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return UsuarioModel.fromJson(response.data!);
    } on DioException catch (error) {
      throw AppException(mapearMensagemErro(error));
    }
  }

  Future<ClienteModel> obterMeuPerfilCliente(String token) async {
    try {
      final response = await apiClient.dio.get<Map<String, dynamic>>(
        '/clientes/me',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return ClienteModel.fromJson(response.data!);
    } on DioException catch (error) {
      throw AppException(mapearMensagemErro(error));
    }
  }
}
