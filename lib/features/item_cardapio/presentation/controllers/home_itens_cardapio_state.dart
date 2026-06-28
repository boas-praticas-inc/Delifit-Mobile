import 'package:equatable/equatable.dart';

import '../../domain/entities/item_cardapio.dart';

class HomeItensCardapioState extends Equatable {
  const HomeItensCardapioState({
    this.carregando = false,
    this.itens = const [],
    this.filtro = '',
    this.erro,
  });

  final bool carregando;
  final List<ItemCardapio> itens;
  final String filtro;
  final String? erro;

  List<ItemCardapio> get filtrados {
    final ativos = itens.where((item) => item.statusItem == 'ATIVO').toList();
    if (filtro.trim().isEmpty) {
      return ativos;
    }

    final query = filtro.toLowerCase();
    return ativos.where((item) {
      return item.nome.toLowerCase().contains(query) ||
          (item.descricao?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  HomeItensCardapioState copyWith({
    bool? carregando,
    List<ItemCardapio>? itens,
    String? filtro,
    String? erro,
    bool limparErro = false,
  }) {
    return HomeItensCardapioState(
      carregando: carregando ?? this.carregando,
      itens: itens ?? this.itens,
      filtro: filtro ?? this.filtro,
      erro: limparErro ? null : (erro ?? this.erro),
    );
  }

  @override
  List<Object?> get props => [carregando, itens, filtro, erro];
}
