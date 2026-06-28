import 'package:equatable/equatable.dart';

class Endereco extends Equatable {
  const Endereco({
    required this.id,
    required this.cep,
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
    this.complemento,
    this.referencia,
    this.label,
  });

  final int id;
  final String cep;
  final String logradouro;
  final String numero;
  final String bairro;
  final String cidade;
  final String estado;
  final String? complemento;
  final String? referencia;
  final String? label;

  @override
  List<Object?> get props => [
        id,
        cep,
        logradouro,
        numero,
        bairro,
        cidade,
        estado,
        complemento,
        referencia,
        label,
      ];
}
