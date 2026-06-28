class UsuarioModel {
  const UsuarioModel({
    required this.id,
    required this.telefone,
    required this.tipoUsuario,
  });

  final int id;
  final String? telefone;
  final String tipoUsuario;

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as int,
      telefone: json['telefone'] as String?,
      tipoUsuario: json['tipo_usuario'] as String,
    );
  }
}

