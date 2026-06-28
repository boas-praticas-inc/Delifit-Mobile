import 'package:flutter/foundation.dart';

import '../../../../app/core/errors/app_exception.dart';
import '../../domain/usecases/entrar_com_telefone_use_case.dart';
import '../../domain/usecases/entrar_como_visitante_use_case.dart';
import '../../domain/usecases/obter_modo_visitante_use_case.dart';
import '../../domain/usecases/obter_sessao_atual_use_case.dart';
import '../../domain/usecases/registrar_cliente_use_case.dart';
import '../../domain/usecases/sair_use_case.dart';
import 'auth_state.dart';

class AuthController extends ChangeNotifier {
  AuthController({
    required EntrarComTelefoneUseCase entrarComTelefoneUseCase,
    required RegistrarClienteUseCase registrarClienteUseCase,
    required ObterSessaoAtualUseCase obterSessaoAtualUseCase,
    required EntrarComoVisitanteUseCase entrarComoVisitanteUseCase,
    required ObterModoVisitanteUseCase obterModoVisitanteUseCase,
    required SairUseCase sairUseCase,
  })  : _entrarComTelefoneUseCase = entrarComTelefoneUseCase,
        _registrarClienteUseCase = registrarClienteUseCase,
        _obterSessaoAtualUseCase = obterSessaoAtualUseCase,
        _entrarComoVisitanteUseCase = entrarComoVisitanteUseCase,
        _obterModoVisitanteUseCase = obterModoVisitanteUseCase,
        _sairUseCase = sairUseCase;

  final EntrarComTelefoneUseCase _entrarComTelefoneUseCase;
  final RegistrarClienteUseCase _registrarClienteUseCase;
  final ObterSessaoAtualUseCase _obterSessaoAtualUseCase;
  final EntrarComoVisitanteUseCase _entrarComoVisitanteUseCase;
  final ObterModoVisitanteUseCase _obterModoVisitanteUseCase;
  final SairUseCase _sairUseCase;

  AuthState _state = const AuthState.inicial();

  AuthState get state => _state;

  Future<void> inicializar() async {
    _state = const AuthState.inicial();
    notifyListeners();

    final sessao = await _obterSessaoAtualUseCase();
    if (sessao != null) {
      _state = AuthState(
        status: AuthStatus.autenticado,
        sessao: sessao,
      );
      notifyListeners();
      return;
    }

    final visitante = await _obterModoVisitanteUseCase();
    _state = AuthState(
      status: visitante ? AuthStatus.visitante : AuthStatus.desautenticado,
    );
    notifyListeners();
  }

  Future<void> login({
    required String telefone,
    required String senha,
  }) async {
    _setLoading();

    try {
      final sessao = await _entrarComTelefoneUseCase(
        telefone: telefone,
        senha: senha,
      );
      _state = AuthState(
        status: AuthStatus.autenticado,
        sessao: sessao,
      );
      notifyListeners();
    } catch (error) {
      _registrarErro(_messageFrom(error));
      rethrow;
    }
  }

  Future<void> registrarCliente({
    required String telefone,
    required String senha,
    required String nomeCompleto,
    required String cpf,
    required DateTime? dataNascimento,
  }) async {
    _setLoading();

    try {
      final sessao = await _registrarClienteUseCase(
        telefone: telefone,
        senha: senha,
        nomeCompleto: nomeCompleto,
        cpf: cpf,
        dataNascimento: dataNascimento,
      );
      _state = AuthState(
        status: AuthStatus.autenticado,
        sessao: sessao,
        precisaCompletarEnderecoInicial: true,
      );
      notifyListeners();
    } catch (error) {
      _registrarErro(_messageFrom(error));
      rethrow;
    }
  }

  Future<void> entrarComoVisitante() async {
    _setLoading();

    try {
      await _entrarComoVisitanteUseCase();
      _state = const AuthState(status: AuthStatus.visitante);
      notifyListeners();
    } catch (error) {
      _registrarErro(_messageFrom(error));
      rethrow;
    }
  }

  Future<void> sair() async {
    await _sairUseCase();
    _state = const AuthState(status: AuthStatus.desautenticado);
    notifyListeners();
  }

  void concluirCadastroEnderecoInicial() {
    _state = _state.copyWith(
      precisaCompletarEnderecoInicial: false,
      limparErro: true,
      carregando: false,
    );
    notifyListeners();
  }

  void limparErro() {
    _state = _state.copyWith(limparErro: true);
    notifyListeners();
  }

  void _setLoading() {
    _state = _state.copyWith(
      carregando: true,
      limparErro: true,
    );
    notifyListeners();
  }

  void _registrarErro(String mensagem) {
    _state = _state.copyWith(
      carregando: false,
      mensagemErro: mensagem,
    );
    notifyListeners();
  }

  String _messageFrom(Object error) {
    if (error is AppException) {
      return error.message;
    }

    return 'Ocorreu um erro inesperado.';
  }
}
