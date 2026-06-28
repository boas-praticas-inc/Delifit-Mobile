import '../entities/item_cardapio.dart';

abstract class ItemCardapioRepository {
  Future<List<ItemCardapio>> listarItensCardapio({int? restauranteId});
}
