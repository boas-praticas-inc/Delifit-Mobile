import 'package:equatable/equatable.dart';

import '../../../endereco/domain/entities/endereco.dart';

class EnderecosState extends Equatable {
  const EnderecosState({
    this.carregando = false,
    this.salvando = false,
    this.enderecos = const [],
    this.erro,
  });

  final bool carregando;
  final bool salvando;
  final List<Endereco> enderecos;
  final String? erro;

  EnderecosState copyWith({
    bool? carregando,
    bool? salvando,
    List<Endereco>? enderecos,
    String? erro,
    bool limparErro = false,
  }) {
    return EnderecosState(
      carregando: carregando ?? this.carregando,
      salvando: salvando ?? this.salvando,
      enderecos: enderecos ?? this.enderecos,
      erro: limparErro ? null : (erro ?? this.erro),
    );
  }

  @override
  List<Object?> get props => [carregando, salvando, enderecos, erro];
}

