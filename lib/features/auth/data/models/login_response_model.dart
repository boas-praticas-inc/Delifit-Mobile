import 'usuario_model.dart';

class LoginResponseModel {
  const LoginResponseModel({
    required this.accessToken,
    required this.usuario,
  });

  final String accessToken;
  final UsuarioModel usuario;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['access_token'] as String,
      usuario: UsuarioModel.fromJson(json['usuario'] as Map<String, dynamic>),
    );
  }
}
