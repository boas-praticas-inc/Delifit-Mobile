class RegistroClienteRequestModel {
  const RegistroClienteRequestModel({
    required this.telefone,
    required this.senha,
    required this.nomeCompleto,
    required this.cpf,
    required this.dataNascimento,
  });

  final String telefone;
  final String senha;
  final String nomeCompleto;
  final String cpf;
  final DateTime? dataNascimento;

  Map<String, dynamic> toJson() {
    return {
      'telefone': telefone,
      'senha': senha,
      'nome_completo': nomeCompleto,
      'cpf': cpf,
      'data_nascimento': dataNascimento?.toIso8601String().split('T').first,
    };
  }
}
