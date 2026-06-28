import 'package:dio/dio.dart';

import '../../../../app/core/errors/app_exception.dart';
import '../../../../app/core/network/api_client.dart';
import '../../../../app/core/network/dio_error_mapper.dart';
import '../../../endereco/data/models/criar_endereco_request_model.dart';
import '../../../endereco/data/models/endereco_model.dart';
import '../models/cartao_cliente_model.dart';
import '../models/cliente_perfil_model.dart';

class ClienteRemoteDataSource {
  const ClienteRemoteDataSource(this.apiClient);

  final ApiClient apiClient;

  Future<ClientePerfilModel> buscarMeuPerfil(String token) async {
    try {
      final response = await apiClient.dio.get<Map<String, dynamic>>(
        '/clientes/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return ClientePerfilModel.fromJson(response.data!);
    } on DioException catch (error) {
      throw AppException(mapearMensagemErro(error));
    }
  }

  Future<ClientePerfilModel> atualizarMeuPerfil({
    required String token,
    required String nomeCompleto,
    required String cpf,
    required String telefone,
    required DateTime? dataNascimento,
  }) async {
    try {
      final response = await apiClient.dio.put<Map<String, dynamic>>(
        '/clientes/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          'nome_completo': nomeCompleto,
          'cpf': cpf,
          'telefone': telefone,
          'data_nascimento': dataNascimento?.toIso8601String().split('T').first,
        },
      );
      return ClientePerfilModel.fromJson(response.data!);
    } on DioException catch (error) {
      throw AppException(mapearMensagemErro(error));
    }
  }

  Future<List<EnderecoModel>> listarMeusEnderecos(String token) async {
    try {
      final response = await apiClient.dio.get<List<dynamic>>(
        '/clientes/me/enderecos',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = response.data ?? <dynamic>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(EnderecoModel.fromJson)
          .toList();
    } on DioException catch (error) {
      throw AppException(mapearMensagemErro(error));
    }
  }

  Future<EnderecoModel> criarMeuEndereco({
    required String token,
    required CriarEnderecoRequestModel payload,
  }) async {
    try {
      final response = await apiClient.dio.post<Map<String, dynamic>>(
        '/clientes/me/enderecos',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: payload.toJson(),
      );
      return EnderecoModel.fromJson(response.data!);
    } on DioException catch (error) {
      throw AppException(mapearMensagemErro(error));
    }
  }

  Future<EnderecoModel> atualizarMeuEndereco({
    required String token,
    required int enderecoId,
    required CriarEnderecoRequestModel payload,
  }) async {
    try {
      final response = await apiClient.dio.put<Map<String, dynamic>>(
        '/clientes/me/enderecos/$enderecoId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: payload.toJson(),
      );
      return EnderecoModel.fromJson(response.data!);
    } on DioException catch (error) {
      throw AppException(mapearMensagemErro(error));
    }
  }

  Future<void> excluirMeuEndereco({
    required String token,
    required int enderecoId,
  }) async {
    try {
      await apiClient.dio.delete<void>(
        '/clientes/me/enderecos/$enderecoId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (error) {
      throw AppException(mapearMensagemErro(error));
    }
  }

  Future<List<CartaoClienteModel>> listarMeusCartoes(String token) async {
    try {
      final response = await apiClient.dio.get<List<dynamic>>(
        '/clientes/me/cartoes',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = response.data ?? <dynamic>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(CartaoClienteModel.fromJson)
          .toList();
    } on DioException catch (error) {
      throw AppException(mapearMensagemErro(error));
    }
  }

  Future<CartaoClienteModel> criarMeuCartao({
    required String token,
    required String nomeTitular,
    required String ultimosQuatroDigitos,
    required String bandeira,
    required bool padrao,
    String? tokenGateway,
  }) async {
    try {
      final response = await apiClient.dio.post<Map<String, dynamic>>(
        '/clientes/me/cartoes',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          'nome_titular': nomeTitular,
          'ultimos_quatro_digitos': ultimosQuatroDigitos,
          'bandeira': bandeira,
          'padrao': padrao,
          'token_gateway': tokenGateway,
        },
      );
      return CartaoClienteModel.fromJson(response.data!);
    } on DioException catch (error) {
      throw AppException(mapearMensagemErro(error));
    }
  }

  Future<CartaoClienteModel> atualizarMeuCartao({
    required String token,
    required int cartaoId,
    required String nomeTitular,
    required String ultimosQuatroDigitos,
    required String bandeira,
    required bool padrao,
    String? tokenGateway,
  }) async {
    try {
      final response = await apiClient.dio.put<Map<String, dynamic>>(
        '/clientes/me/cartoes/$cartaoId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          'nome_titular': nomeTitular,
          'ultimos_quatro_digitos': ultimosQuatroDigitos,
          'bandeira': bandeira,
          'padrao': padrao,
          'token_gateway': tokenGateway,
        },
      );
      return CartaoClienteModel.fromJson(response.data!);
    } on DioException catch (error) {
      throw AppException(mapearMensagemErro(error));
    }
  }

  Future<void> excluirMeuCartao({
    required String token,
    required int cartaoId,
  }) async {
    try {
      await apiClient.dio.delete<void>(
        '/clientes/me/cartoes/$cartaoId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (error) {
      throw AppException(mapearMensagemErro(error));
    }
  }
}

