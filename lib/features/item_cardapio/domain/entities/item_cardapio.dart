import 'package:equatable/equatable.dart';

import 'variacao_item_cardapio.dart';

class ItemCardapio extends Equatable {
  const ItemCardapio({
    required this.id,
    required this.restauranteId,
    required this.categoriaId,
    required this.nome,
    this.descricao,
    required this.variacoes,
    required this.tags,
    required this.statusItem,
    this.fotoUrl,
    required this.criadoEm,
    required this.atualizadoEm,
  });

  final int id;
  final int restauranteId;
  final int categoriaId;
  final String nome;
  final String? descricao;
  final List<VariacaoItemCardapio> variacoes;
  final List<String> tags;
  final String statusItem;
  final String? fotoUrl;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  VariacaoItemCardapio? get variacaoPrincipal {
    if (variacoes.isEmpty) {
      return null;
    }
    return variacoes.first;
  }

  @override
  List<Object?> get props => [
        id,
        restauranteId,
        categoriaId,
        nome,
        descricao,
        variacoes,
        tags,
        statusItem,
        fotoUrl,
        criadoEm,
        atualizadoEm,
      ];
}
