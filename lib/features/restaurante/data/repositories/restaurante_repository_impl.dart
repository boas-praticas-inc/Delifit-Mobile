import '../../domain/entities/restaurante.dart';
import '../../domain/repositories/restaurante_repository.dart';
import '../datasources/restaurante_remote_data_source.dart';

class RestauranteRepositoryImpl implements RestauranteRepository {
  const RestauranteRepositoryImpl(this.remoteDataSource);

  final RestauranteRemoteDataSource remoteDataSource;

  @override
  Future<List<Restaurante>> listarRestaurantes() {
    return remoteDataSource.listarRestaurantes();
  }
}

