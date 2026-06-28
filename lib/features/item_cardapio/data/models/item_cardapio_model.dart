import '../../domain/entities/item_cardapio.dart';
import 'variacao_item_cardapio_model.dart';

class ItemCardapioModel extends ItemCardapio {
  const ItemCardapioModel({
    required super.id,
    required super.restauranteId,
    required super.categoriaId,
    required super.nome,
    super.descricao,
    required super.variacoes,
    required super.tags,
    required super.statusItem,
    super.fotoUrl,
    required super.criadoEm,
    required super.atualizadoEm,
  });

  factory ItemCardapioModel.fromJson(Map<String, dynamic> json) {
    final variacoesJson = json['variacoes'] as List<dynamic>? ?? <dynamic>[];
    final tagsJson = json['tags'] as List<dynamic>? ?? <dynamic>[];

    return ItemCardapioModel(
      id: json['id'] as int,
      restauranteId: json['restaurante_id'] as int,
      categoriaId: json['categoria_id'] as int,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String?,
      variacoes: variacoesJson
          .whereType<Map<String, dynamic>>()
          .map(VariacaoItemCardapioModel.fromJson)
          .toList(),
      tags: tagsJson.map((tag) => tag.toString()).toList(),
      statusItem: json['status_item'] as String,
      fotoUrl: json['foto_url'] as String?,
      criadoEm: DateTime.parse(json['criado_em'] as String),
      atualizadoEm: DateTime.parse(json['atualizado_em'] as String),
    );
  }
}
