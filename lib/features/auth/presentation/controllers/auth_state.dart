import 'package:equatable/equatable.dart';

import '../../domain/entities/sessao_usuario.dart';

enum AuthStatus {
  inicializando,
  desautenticado,
  autenticado,
  visitante,
}

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    this.sessao,
    this.carregando = false,
    this.mensagemErro,
    this.precisaCompletarEnderecoInicial = false,
  });

  const AuthState.inicial()
      : status = AuthStatus.inicializando,
        sessao = null,
        carregando = false,
        mensagemErro = null,
        precisaCompletarEnderecoInicial = false;

  final AuthStatus status;
  final SessaoUsuario? sessao;
  final bool carregando;
  final String? mensagemErro;
  final bool precisaCompletarEnderecoInicial;

  bool get autenticado => status == AuthStatus.autenticado;
  bool get visitante => status == AuthStatus.visitante;

  AuthState copyWith({
    AuthStatus? status,
    SessaoUsuario? sessao,
    bool? carregando,
    String? mensagemErro,
    bool limparErro = false,
    bool? precisaCompletarEnderecoInicial,
    bool limparSessao = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      sessao: limparSessao ? null : (sessao ?? this.sessao),
      carregando: carregando ?? this.carregando,
      mensagemErro: limparErro ? null : (mensagemErro ?? this.mensagemErro),
      precisaCompletarEnderecoInicial:
          precisaCompletarEnderecoInicial ?? this.precisaCompletarEnderecoInicial,
    );
  }

  @override
  List<Object?> get props => [
        status,
        sessao,
        carregando,
        mensagemErro,
        precisaCompletarEnderecoInicial,
      ];
}

