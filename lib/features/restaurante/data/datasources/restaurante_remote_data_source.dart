import 'package:dio/dio.dart';

import '../../../../app/core/errors/app_exception.dart';
import '../../../../app/core/network/api_client.dart';
import '../../../../app/core/network/dio_error_mapper.dart';
import '../models/restaurante_model.dart';

class RestauranteRemoteDataSource {
  const RestauranteRemoteDataSource(this.apiClient);

  final ApiClient apiClient;

  Future<List<RestauranteModel>> listarRestaurantes() async {
    try {
      final response = await apiClient.dio.get<List<dynamic>>('/restaurantes');
      final data = response.data ?? <dynamic>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(RestauranteModel.fromJson)
          .toList();
    } on DioException catch (error) {
      throw AppException(mapearMensagemErro(error));
    }
  }
}

