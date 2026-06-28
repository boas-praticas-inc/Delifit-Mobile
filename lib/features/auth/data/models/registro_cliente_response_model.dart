import 'cliente_model.dart';
import 'usuario_model.dart';

class RegistroClienteResponseModel {
  const RegistroClienteResponseModel({
    required this.accessToken,
    required this.usuario,
    required this.cliente,
  });

  final String accessToken;
  final UsuarioModel usuario;
  final ClienteModel cliente;

  factory RegistroClienteResponseModel.fromJson(Map<String, dynamic> json) {
    return RegistroClienteResponseModel(
      accessToken: json['access_token'] as String,
      usuario: UsuarioModel.fromJson(json['usuario'] as Map<String, dynamic>),
      cliente: ClienteModel.fromJson(json['cliente'] as Map<String, dynamic>),
    );
  }
}

