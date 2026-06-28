import '../entities/restaurante.dart';
import '../repositories/restaurante_repository.dart';

class ListarRestaurantesUseCase {
  const ListarRestaurantesUseCase(this.repository);

  final RestauranteRepository repository;

  Future<List<Restaurante>> call() => repository.listarRestaurantes();
}

