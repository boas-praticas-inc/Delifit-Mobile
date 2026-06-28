import '../../domain/entities/item_cardapio.dart';
import '../../domain/repositories/item_cardapio_repository.dart';
import '../datasources/item_cardapio_remote_data_source.dart';

class ItemCardapioRepositoryImpl implements ItemCardapioRepository {
  const ItemCardapioRepositoryImpl(this.remoteDataSource);

  final ItemCardapioRemoteDataSource remoteDataSource;

  @override
  Future<List<ItemCardapio>> listarItensCardapio({int? restauranteId}) {
    return remoteDataSource.listarItensCardapio(restauranteId: restauranteId);
  }
}
