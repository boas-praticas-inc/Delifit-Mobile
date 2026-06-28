import 'package:flutter/foundation.dart';

import '../../../../app/core/errors/app_exception.dart';
import '../../domain/usecases/listar_itens_cardapio_use_case.dart';
import 'home_itens_cardapio_state.dart';

class HomeItensCardapioController extends ChangeNotifier {
  HomeItensCardapioController({
    required ListarItensCardapioUseCase listarItensCardapioUseCase,
  }) : _listarItensCardapioUseCase = listarItensCardapioUseCase;

  final ListarItensCardapioUseCase _listarItensCardapioUseCase;

  HomeItensCardapioState _state = const HomeItensCardapioState();

  HomeItensCardapioState get state => _state;

  Future<void> carregar() async {
    _state = _state.copyWith(carregando: true, limparErro: true);
    notifyListeners();

    try {
      final itens = await _listarItensCardapioUseCase();
      _state = _state.copyWith(carregando: false, itens: itens);
      notifyListeners();
    } catch (error) {
      final mensagem = error is AppException
          ? error.message
          : 'Não foi possível carregar os itens do cardápio.';
      _state = _state.copyWith(carregando: false, erro: mensagem);
      notifyListeners();
    }
  }

  void atualizarFiltro(String value) {
    _state = _state.copyWith(filtro: value);
    notifyListeners();
  }
}
