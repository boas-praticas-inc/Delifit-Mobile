import 'package:equatable/equatable.dart';

import '../../domain/entities/cartao_cliente.dart';

class CartoesState extends Equatable {
  const CartoesState({
    this.carregando = false,
    this.salvando = false,
    this.cartoes = const [],
    this.erro,
  });

  final bool carregando;
  final bool salvando;
  final List<CartaoCliente> cartoes;
  final String? erro;

  CartoesState copyWith({
    bool? carregando,
    bool? salvando,
    List<CartaoCliente>? cartoes,
    String? erro,
    bool limparErro = false,
  }) {
    return CartoesState(
      carregando: carregando ?? this.carregando,
      salvando: salvando ?? this.salvando,
      cartoes: cartoes ?? this.cartoes,
      erro: limparErro ? null : (erro ?? this.erro),
    );
  }

  @override
  List<Object?> get props => [carregando, salvando, cartoes, erro];
}

