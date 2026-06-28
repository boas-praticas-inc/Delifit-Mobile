import 'package:flutter/foundation.dart';

import '../../../../app/core/errors/app_exception.dart';
import '../../domain/usecases/excluir_meu_cartao_use_case.dart';
import '../../domain/usecases/listar_meus_cartoes_use_case.dart';
import '../../domain/usecases/salvar_meu_cartao_use_case.dart';
import 'cartoes_state.dart';

class CartoesController extends ChangeNotifier {
  CartoesController({
    required ListarMeusCartoesUseCase listarMeusCartoesUseCase,
    required SalvarMeuCartaoUseCase salvarMeuCartaoUseCase,
    required ExcluirMeuCartaoUseCase excluirMeuCartaoUseCase,
  })  : _listarMeusCartoesUseCase = listarMeusCartoesUseCase,
        _salvarMeuCartaoUseCase = salvarMeuCartaoUseCase,
        _excluirMeuCartaoUseCase = excluirMeuCartaoUseCase;

  final ListarMeusCartoesUseCase _listarMeusCartoesUseCase;
  final SalvarMeuCartaoUseCase _salvarMeuCartaoUseCase;
  final ExcluirMeuCartaoUseCase _excluirMeuCartaoUseCase;

  CartoesState _state = const CartoesState();

  CartoesState get state => _state;

  Future<void> carregar() async {
    _state = _state.copyWith(carregando: true, limparErro: true);
    notifyListeners();
    try {
      final cartoes = await _listarMeusCartoesUseCase();
      _state = _state.copyWith(carregando: false, cartoes: cartoes);
      notifyListeners();
    } catch (error) {
      _state = _state.copyWith(
        carregando: false,
        erro: error is AppException ? error.message : 'Não foi possível carregar os cartões.',
      );
      notifyListeners();
    }
  }

  Future<bool> salvar({
    required int? cartaoId,
    required String nomeTitular,
    required String ultimosQuatroDigitos,
    required String bandeira,
    required bool padrao,
    String? tokenGateway,
  }) async {
    _state = _state.copyWith(salvando: true, limparErro: true);
    notifyListeners();
    try {
      if (cartaoId == null) {
        await _salvarMeuCartaoUseCase.criar(
          nomeTitular: nomeTitular,
          ultimosQuatroDigitos: ultimosQuatroDigitos,
          bandeira: bandeira,
          padrao: padrao,
          tokenGateway: tokenGateway,
        );
      } else {
        await _salvarMeuCartaoUseCase.atualizar(
          cartaoId: cartaoId,
          nomeTitular: nomeTitular,
          ultimosQuatroDigitos: ultimosQuatroDigitos,
          bandeira: bandeira,
          padrao: padrao,
          tokenGateway: tokenGateway,
        );
      }
      await carregar();
      _state = _state.copyWith(salvando: false);
      notifyListeners();
      return true;
    } catch (error) {
      _state = _state.copyWith(
        salvando: false,
        erro: error is AppException ? error.message : 'Não foi possível salvar o cartão.',
      );
      notifyListeners();
      return false;
    }
  }

  Future<void> excluir(int cartaoId) async {
    _state = _state.copyWith(salvando: true, limparErro: true);
    notifyListeners();
    try {
      await _excluirMeuCartaoUseCase(cartaoId);
      await carregar();
      _state = _state.copyWith(salvando: false);
      notifyListeners();
    } catch (error) {
      _state = _state.copyWith(
        salvando: false,
        erro: error is AppException ? error.message : 'Não foi possível excluir o cartão.',
      );
      notifyListeners();
    }
  }
}


