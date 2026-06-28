import 'package:equatable/equatable.dart';

class Restaurante extends Equatable {
  const Restaurante({
    required this.id,
    required this.nomeFantasia,
    required this.razaoSocial,
    required this.cnpj,
    required this.telefone,
    required this.status,
    this.descricao,
    this.fotoUrl,
  });

  final int id;
  final String nomeFantasia;
  final String razaoSocial;
  final String cnpj;
  final String telefone;
  final String status;
  final String? descricao;
  final String? fotoUrl;

  @override
  List<Object?> get props => [
        id,
        nomeFantasia,
        razaoSocial,
        cnpj,
        telefone,
        status,
        descricao,
        fotoUrl,
      ];
}

