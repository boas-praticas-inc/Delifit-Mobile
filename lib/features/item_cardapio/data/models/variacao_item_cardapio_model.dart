import '../../domain/entities/variacao_item_cardapio.dart';

class VariacaoItemCardapioModel extends VariacaoItemCardapio {
  const VariacaoItemCardapioModel({
    super.id,
    required super.descricaoVariacao,
    super.quantidade,
    super.unidadeMedida,
    required super.preco,
    required super.carboidratos,
    required super.gorduras,
    required super.proteina,
    required super.caloria,
  });

  factory VariacaoItemCardapioModel.fromJson(Map<String, dynamic> json) {
    return VariacaoItemCardapioModel(
      id: json['id'] as int?,
      descricaoVariacao: json['descricao_variacao'] as String,
      quantidade: (json['quantidade'] as num?)?.toDouble(),
      unidadeMedida: json['unidade_medida'] as String?,
      preco: (json['preco'] as num).toDouble(),
      carboidratos: (json['carboidratos'] as num).toDouble(),
      gorduras: (json['gorduras'] as num).toDouble(),
      proteina: (json['proteina'] as num).toDouble(),
      caloria: (json['caloria'] as num).toDouble(),
    );
  }
}
