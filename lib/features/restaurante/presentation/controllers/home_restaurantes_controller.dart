import 'package:flutter/foundation.dart';

import '../../../../app/core/errors/app_exception.dart';
import '../../domain/usecases/listar_restaurantes_use_case.dart';
import 'home_restaurantes_state.dart';

class HomeRestaurantesController extends ChangeNotifier {
  HomeRestaurantesController({required ListarRestaurantesUseCase listarRestaurantesUseCase})
      : _listarRestaurantesUseCase = listarRestaurantesUseCase;

  final ListarRestaurantesUseCase _listarRestaurantesUseCase;

  HomeRestaurantesState _state = const HomeRestaurantesState();

  HomeRestaurantesState get state => _state;

  Future<void> carregar() async {
    _state = _state.copyWith(carregando: true, limparErro: true);
    notifyListeners();

    try {
      final restaurantes = await _listarRestaurantesUseCase();
      _state = _state.copyWith(
        carregando: false,
        restaurantes: restaurantes,
      );
      notifyListeners();
    } catch (error) {
      final message = error is AppException
          ? error.message
          : 'Não foi possível carregar os restaurantes.';
      _state = _state.copyWith(carregando: false, erro: message);
      notifyListeners();
    }
  }

  void atualizarFiltro(String value) {
    _state = _state.copyWith(filtro: value);
    notifyListeners();
  }
}


