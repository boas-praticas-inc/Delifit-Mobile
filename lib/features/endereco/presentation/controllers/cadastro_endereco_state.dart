import 'package:equatable/equatable.dart';

class CadastroEnderecoState extends Equatable {
  const CadastroEnderecoState({
    this.carregando = false,
    this.mensagemErro,
    this.sucesso = false,
  });

  final bool carregando;
  final String? mensagemErro;
  final bool sucesso;

  CadastroEnderecoState copyWith({
    bool? carregando,
    String? mensagemErro,
    bool limparErro = false,
    bool? sucesso,
  }) {
    return CadastroEnderecoState(
      carregando: carregando ?? this.carregando,
      mensagemErro: limparErro ? null : (mensagemErro ?? this.mensagemErro),
      sucesso: sucesso ?? this.sucesso,
    );
  }

  @override
  List<Object?> get props => [carregando, mensagemErro, sucesso];
}
