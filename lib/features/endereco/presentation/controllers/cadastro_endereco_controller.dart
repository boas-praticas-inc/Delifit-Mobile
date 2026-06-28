import 'package:flutter/foundation.dart';

import '../../../../app/core/errors/app_exception.dart';
import '../../domain/usecases/criar_meu_endereco_use_case.dart';
import 'cadastro_endereco_state.dart';

class CadastroEnderecoController extends ChangeNotifier {
  CadastroEnderecoController({required CriarMeuEnderecoUseCase criarMeuEnderecoUseCase})
      : _criarMeuEnderecoUseCase = criarMeuEnderecoUseCase;

  final CriarMeuEnderecoUseCase _criarMeuEnderecoUseCase;

  CadastroEnderecoState _state = const CadastroEnderecoState();

  CadastroEnderecoState get state => _state;

  Future<void> criarEnderecoInicial({
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
    _state = _state.copyWith(carregando: true, limparErro: true, sucesso: false);
    notifyListeners();

    try {
      await _criarMeuEnderecoUseCase(
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
      _state = const CadastroEnderecoState(sucesso: true);
      notifyListeners();
    } catch (error) {
      final mensagem = error is AppException
          ? error.message
          : 'Não foi possível salvar o endereço.';
      _state = _state.copyWith(carregando: false, mensagemErro: mensagem);
      notifyListeners();
      rethrow;
    }
  }

  void limparErro() {
    _state = _state.copyWith(limparErro: true);
    notifyListeners();
  }
}


