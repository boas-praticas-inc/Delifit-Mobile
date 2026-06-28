import 'package:flutter/foundation.dart';

import '../../../../app/core/errors/app_exception.dart';
import '../../domain/usecases/atualizar_meu_perfil_use_case.dart';
import '../../domain/usecases/buscar_meu_perfil_use_case.dart';
import 'perfil_cliente_state.dart';

class PerfilClienteController extends ChangeNotifier {
  PerfilClienteController({
    required BuscarMeuPerfilUseCase buscarMeuPerfilUseCase,
    required AtualizarMeuPerfilUseCase atualizarMeuPerfilUseCase,
  })  : _buscarMeuPerfilUseCase = buscarMeuPerfilUseCase,
        _atualizarMeuPerfilUseCase = atualizarMeuPerfilUseCase;

  final BuscarMeuPerfilUseCase _buscarMeuPerfilUseCase;
  final AtualizarMeuPerfilUseCase _atualizarMeuPerfilUseCase;

  PerfilClienteState _state = const PerfilClienteState();

  PerfilClienteState get state => _state;

  Future<void> carregar() async {
    _state = _state.copyWith(carregando: true, limparErro: true, sucesso: false);
    notifyListeners();
    try {
      final perfil = await _buscarMeuPerfilUseCase();
      _state = _state.copyWith(carregando: false, perfil: perfil);
      notifyListeners();
    } catch (error) {
      _state = _state.copyWith(
        carregando: false,
        erro: error is AppException ? error.message : 'Não foi possível carregar o perfil.',
      );
      notifyListeners();
    }
  }

  Future<bool> salvar({
    required String nomeCompleto,
    required String cpf,
    required String telefone,
    required DateTime? dataNascimento,
  }) async {
    _state = _state.copyWith(salvando: true, limparErro: true, sucesso: false);
    notifyListeners();

    try {
      final perfil = await _atualizarMeuPerfilUseCase(
        nomeCompleto: nomeCompleto,
        cpf: cpf,
        telefone: telefone,
        dataNascimento: dataNascimento,
      );
      _state = _state.copyWith(salvando: false, perfil: perfil, sucesso: true);
      notifyListeners();
      return true;
    } catch (error) {
      _state = _state.copyWith(
        salvando: false,
        erro: error is AppException ? error.message : 'Não foi possível salvar o perfil.',
      );
      notifyListeners();
      return false;
    }
  }
}


