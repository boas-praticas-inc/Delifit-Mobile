import 'package:equatable/equatable.dart';

class ClientePerfil extends Equatable {
  const ClientePerfil({
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

  @override
  List<Object?> get props => [id, usuarioId, nomeCompleto, cpf, telefone, dataNascimento];
}

