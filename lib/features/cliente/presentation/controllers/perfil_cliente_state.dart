import 'package:equatable/equatable.dart';

import '../../domain/entities/cliente_perfil.dart';

class PerfilClienteState extends Equatable {
  const PerfilClienteState({
    this.carregando = false,
    this.salvando = false,
    this.perfil,
    this.erro,
    this.sucesso = false,
  });

  final bool carregando;
  final bool salvando;
  final ClientePerfil? perfil;
  final String? erro;
  final bool sucesso;

  PerfilClienteState copyWith({
    bool? carregando,
    bool? salvando,
    ClientePerfil? perfil,
    String? erro,
    bool limparErro = false,
    bool? sucesso,
  }) {
    return PerfilClienteState(
      carregando: carregando ?? this.carregando,
      salvando: salvando ?? this.salvando,
      perfil: perfil ?? this.perfil,
      erro: limparErro ? null : (erro ?? this.erro),
      sucesso: sucesso ?? this.sucesso,
    );
  }

  @override
  List<Object?> get props => [carregando, salvando, perfil, erro, sucesso];
}

