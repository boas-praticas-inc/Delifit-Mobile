import 'package:delifit_mobile/features/auth/domain/entities/sessao_usuario.dart';
import 'package:delifit_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:delifit_mobile/features/auth/domain/usecases/entrar_com_telefone_use_case.dart';
import 'package:delifit_mobile/features/auth/domain/usecases/entrar_como_visitante_use_case.dart';
import 'package:delifit_mobile/features/auth/domain/usecases/obter_modo_visitante_use_case.dart';
import 'package:delifit_mobile/features/auth/domain/usecases/obter_sessao_atual_use_case.dart';
import 'package:delifit_mobile/features/auth/domain/usecases/registrar_cliente_use_case.dart';
import 'package:delifit_mobile/features/auth/domain/usecases/sair_use_case.dart';
import 'package:delifit_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:delifit_mobile/features/auth/presentation/pages/entrada_page.dart';
import 'package:delifit_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:delifit_mobile/app/core/di/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<void> entrarComoVisitante() async {}

  @override
  Future<SessaoUsuario> entrarComTelefone({required String telefone, required String senha}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> obterModoVisitante() async => false;

  @override
  Future<SessaoUsuario?> obterSessaoAtual() async => null;

  @override
  Future<SessaoUsuario> registrarCliente({
    required String telefone,
    required String senha,
    required String nomeCompleto,
    required String cpf,
    required DateTime? dataNascimento,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> sair() async {}
}

AuthController _buildController() {
  final repository = _FakeAuthRepository();
  return AuthController(
    entrarComTelefoneUseCase: EntrarComTelefoneUseCase(repository),
    registrarClienteUseCase: RegistrarClienteUseCase(repository),
    obterSessaoAtualUseCase: ObterSessaoAtualUseCase(repository),
    entrarComoVisitanteUseCase: EntrarComoVisitanteUseCase(repository),
    obterModoVisitanteUseCase: ObterModoVisitanteUseCase(repository),
    sairUseCase: SairUseCase(repository),
  );
}

void main() {
  testWidgets('renderiza tela de entrada com ações principais', (tester) async {
    final controller = _buildController();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith((ref) => controller),
        ],
        child: const MaterialApp(home: EntradaPage()),
      ),
    );

    expect(find.text('Entrar com celular'), findsOneWidget);
    expect(find.text('Criar conta'), findsOneWidget);
    expect(find.text('Entrar como visitante'), findsOneWidget);
  });

  testWidgets('valida campos obrigatórios do login', (tester) async {
    final controller = _buildController();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith((ref) => controller),
        ],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(find.text('Informe um celular válido.'), findsOneWidget);
    expect(find.text('A senha deve ter pelo menos 8 caracteres.'), findsOneWidget);
  });
}
