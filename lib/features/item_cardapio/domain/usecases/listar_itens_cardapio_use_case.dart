import '../entities/item_cardapio.dart';
import '../repositories/item_cardapio_repository.dart';

class ListarItensCardapioUseCase {
  const ListarItensCardapioUseCase(this.repository);

  final ItemCardapioRepository repository;

  Future<List<ItemCardapio>> call({int? restauranteId}) {
    return repository.listarItensCardapio(restauranteId: restauranteId);
  }
}
