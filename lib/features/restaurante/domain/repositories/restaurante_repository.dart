import '../entities/restaurante.dart';

abstract class RestauranteRepository {
  Future<List<Restaurante>> listarRestaurantes();
}

