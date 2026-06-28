import 'package:flutter/foundation.dart';

import '../../../../app/core/errors/app_exception.dart';
import '../../domain/usecases/excluir_meu_endereco_use_case.dart';
import '../../domain/usecases/listar_meus_enderecos_use_case.dart';
import '../../domain/usecases/salvar_meu_endereco_use_case.dart';
import 'enderecos_state.dart';

class EnderecosController extends ChangeNotifier {
  EnderecosController({
    required ListarMeusEnderecosUseCase listarMeusEnderecosUseCase,
    required SalvarMeuEnderecoUseCase salvarMeuEnderecoUseCase,
    required ExcluirMeuEnderecoUseCase excluirMeuEnderecoUseCase,
  })  : _listarMeusEnderecosUseCase = listarMeusEnderecosUseCase,
        _salvarMeuEnderecoUseCase = salvarMeuEnderecoUseCase,
        _excluirMeuEnderecoUseCase = excluirMeuEnderecoUseCase;

  final ListarMeusEnderecosUseCase _listarMeusEnderecosUseCase;
  final SalvarMeuEnderecoUseCase _salvarMeuEnderecoUseCase;
  final ExcluirMeuEnderecoUseCase _excluirMeuEnderecoUseCase;

  EnderecosState _state = const EnderecosState();

  EnderecosState get state => _state;

  Future<void> carregar() async {
    _state = _state.copyWith(carregando: true, limparErro: true);
    notifyListeners();
    try {
      final enderecos = await _listarMeusEnderecosUseCase();
      _state = _state.copyWith(carregando: false, enderecos: enderecos);
      notifyListeners();
    } catch (error) {
      _state = _state.copyWith(
        carregando: false,
        erro: error is AppException ? error.message : 'Não foi possível carregar os endereços.',
      );
      notifyListeners();
    }
  }

  Future<bool> salvar({
    required int? enderecoId,
    required String cep,
    required String logradouro,
    required String numero,
    required String bairro,
    required String cidade,
    required String estado,
    String? complemento,
    String? referencia,
    String? label,
  }) async {
    _state = _state.copyWith(salvando: true, limparErro: true);
    notifyListeners();
    try {
      if (enderecoId == null) {
        await _salvarMeuEnderecoUseCase.criar(
          cep: cep,
          logradouro: logradouro,
          numero: numero,
          bairro: bairro,
          cidade: cidade,
          estado: estado,
          complemento: complemento,
          referencia: referencia,
          label: label,
        );
      } else {
        await _salvarMeuEnderecoUseCase.atualizar(
          enderecoId: enderecoId,
          cep: cep,
          logradouro: logradouro,
          numero: numero,
          bairro: bairro,
          cidade: cidade,
          estado: estado,
          complemento: complemento,
          referencia: referencia,
          label: label,
        );
      }
      await carregar();
      _state = _state.copyWith(salvando: false);
      notifyListeners();
      return true;
    } catch (error) {
      _state = _state.copyWith(
        salvando: false,
        erro: error is AppException ? error.message : 'Não foi possível salvar o endereço.',
      );
      notifyListeners();
      return false;
    }
  }

  Future<void> excluir(int enderecoId) async {
    _state = _state.copyWith(salvando: true, limparErro: true);
    notifyListeners();
    try {
      await _excluirMeuEnderecoUseCase(enderecoId);
      await carregar();
      _state = _state.copyWith(salvando: false);
      notifyListeners();
    } catch (error) {
      _state = _state.copyWith(
        salvando: false,
        erro: error is AppException ? error.message : 'Não foi possível excluir o endereço.',
      );
      notifyListeners();
    }
  }
}


