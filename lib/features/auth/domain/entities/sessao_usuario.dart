import 'package:equatable/equatable.dart';

class SessaoUsuario extends Equatable {
  const SessaoUsuario({
    required this.accessToken,
    required this.usuarioId,
    required this.telefone,
    required this.tipoUsuario,
    this.nomeCompleto,
  });

  final String accessToken;
  final int usuarioId;
  final String? telefone;
  final String tipoUsuario;
  final String? nomeCompleto;

  @override
  List<Object?> get props => [
        accessToken,
        usuarioId,
        telefone,
        tipoUsuario,
        nomeCompleto,
      ];
}
