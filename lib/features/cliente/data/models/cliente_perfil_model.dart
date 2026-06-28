import '../../domain/entities/cliente_perfil.dart';

class ClientePerfilModel extends ClientePerfil {
  const ClientePerfilModel({
    required super.id,
    required super.usuarioId,
    required super.nomeCompleto,
    required super.cpf,
    required super.telefone,
    super.dataNascimento,
  });

  factory ClientePerfilModel.fromJson(Map<String, dynamic> json) {
    return ClientePerfilModel(
      id: json['id'] as int,
      usuarioId: json['usuario_id'] as int,
      nomeCompleto: json['nome_completo'] as String,
      cpf: json['cpf'] as String,
      telefone: json['telefone'] as String?,
      dataNascimento: json['data_nascimento'] as String?,
    );
  }
}

