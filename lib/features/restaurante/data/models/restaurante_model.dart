import '../../domain/entities/restaurante.dart';

class RestauranteModel extends Restaurante {
  const RestauranteModel({
    required super.id,
    required super.nomeFantasia,
    required super.razaoSocial,
    required super.cnpj,
    required super.telefone,
    required super.status,
    super.descricao,
    super.fotoUrl,
  });

  factory RestauranteModel.fromJson(Map<String, dynamic> json) {
    return RestauranteModel(
      id: json['id'] as int,
      nomeFantasia: json['nome_fantasia'] as String,
      razaoSocial: json['razao_social'] as String,
      cnpj: json['cnpj'] as String,
      telefone: json['telefone'] as String,
      status: json['status'] as String,
      descricao: json['descricao'] as String?,
      fotoUrl: json['foto_url'] as String?,
    );
  }
}

