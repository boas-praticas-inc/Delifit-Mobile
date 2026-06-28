class ClienteModel {
  const ClienteModel({
    required this.id,
    required this.usuarioId,
    required this.nomeCompleto,
    required this.cpf,
    required this.telefone,
    this.dataNascimento,
  });

  final int id;
  final int usuarioId;
  final String nomeCompleto;
  final String cpf;
  final String? telefone;
  final String? dataNascimento;

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      id: json['id'] as int,
      usuarioId: json['usuario_id'] as int,
      nomeCompleto: json['nome_completo'] as String,
      cpf: json['cpf'] as String,
      telefone: json['telefone'] as String?,
      dataNascimento: json['data_nascimento'] as String?,
    );
  }
}
