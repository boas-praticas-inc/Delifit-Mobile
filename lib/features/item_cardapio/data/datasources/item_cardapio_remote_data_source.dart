import 'package:dio/dio.dart';

import '../../../../app/core/errors/app_exception.dart';
import '../../../../app/core/network/api_client.dart';
import '../../../../app/core/network/dio_error_mapper.dart';
import '../models/item_cardapio_model.dart';

class ItemCardapioRemoteDataSource {
  const ItemCardapioRemoteDataSource(this.apiClient);

  final ApiClient apiClient;

  Future<List<ItemCardapioModel>> listarItensCardapio({int? restauranteId}) async {
    try {
      final response = await apiClient.dio.get<List<dynamic>>(
        '/itens-cardapio',
        queryParameters: restauranteId == null
            ? null
            : <String, dynamic>{'restaurante_id': restauranteId},
      );
      final data = response.data ?? <dynamic>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(ItemCardapioModel.fromJson)
          .toList();
    } on DioException catch (error) {
      throw AppException(mapearMensagemErro(error));
    }
  }
}
