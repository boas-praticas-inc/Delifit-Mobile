import '../../domain/entities/endereco.dart';

class EnderecoModel extends Endereco {
  const EnderecoModel({
    required super.id,
    required super.cep,
    required super.logradouro,
    required super.numero,
    required super.bairro,
    required super.cidade,
    required super.estado,
    super.complemento,
    super.referencia,
    super.label,
  });

  factory EnderecoModel.fromJson(Map<String, dynamic> json) {
    return EnderecoModel(
      id: json['id'] as int,
      cep: json['cep'] as String,
      logradouro: json['logradouro'] as String,
      numero: json['numero'] as String,
      bairro: json['bairro'] as String,
      cidade: json['cidade'] as String,
      estado: json['estado'] as String,
      complemento: json['complemento'] as String?,
      referencia: json['referencia'] as String?,
      label: json['label'] as String?,
    );
  }
}

