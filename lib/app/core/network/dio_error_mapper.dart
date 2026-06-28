import 'package:dio/dio.dart';

String mapearMensagemErro(DioException error) {
  final data = error.response?.data;

  if (data is Map<String, dynamic>) {
    final detail = data['detail'];
    if (detail is String && detail.trim().isNotEmpty) {
      return detail;
    }

    if (detail is List && detail.isNotEmpty) {
      final first = detail.first;
      if (first is Map<String, dynamic>) {
        final message = first['msg'];
        if (message is String && message.trim().isNotEmpty) {
          return message;
        }
      }
    }
  }

  if (error.type == DioExceptionType.connectionError ||
      error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout) {
    return 'Não foi possível conectar com a API.';
  }

  return 'Ocorreu um erro inesperado.';
}


