import 'package:equatable/equatable.dart';

class VariacaoItemCardapio extends Equatable {
  const VariacaoItemCardapio({
    this.id,
    required this.descricaoVariacao,
    this.quantidade,
    this.unidadeMedida,
    required this.preco,
    required this.carboidratos,
    required this.gorduras,
    required this.proteina,
    required this.caloria,
  });

  final int? id;
  final String descricaoVariacao;
  final double? quantidade;
  final String? unidadeMedida;
  final double preco;
  final double carboidratos;
  final double gorduras;
  final double proteina;
  final double caloria;

  @override
  List<Object?> get props => [
        id,
        descricaoVariacao,
        quantidade,
        unidadeMedida,
        preco,
        carboidratos,
        gorduras,
        proteina,
        caloria,
      ];
}
