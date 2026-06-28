import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../app/core/di/providers.dart';
import '../../../../app/core/utils/text_sanitizer.dart';
import '../../../../app/routes/app_routes.dart';
import '../widgets/auth_scaffold.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _telefoneMask = MaskTextInputFormatter(mask: '(##) #####-####');

  @override
  void dispose() {
    _telefoneController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(authControllerProvider).login(
            telefone: TextSanitizer.apenasDigitos(_telefoneController.text),
            senha: _senhaController.text,
          );
    } catch (_) {
      final mensagem = ref.read(authControllerProvider).state.mensagemErro;
      messenger.showSnackBar(
        SnackBar(content: Text(mensagem ?? 'Nao foi possivel entrar.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider).state;

    return AuthScaffold(
      title: 'Entre na sua conta',
      subtitle: 'Use o numero de celular cadastrado para continuar.',
      footer: TextButton(
        onPressed: state.carregando ? null : () => context.go(AppRoutes.cadastro),
        child: const Text('Ainda nao tem conta? Criar agora'),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _telefoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [_telefoneMask],
              decoration: const InputDecoration(
                labelText: 'Celular',
                hintText: '(11) 99999-9999',
              ),
              validator: (value) {
                if (value == null || TextSanitizer.apenasDigitos(value).length < 10) {
                  return 'Informe um celular valido.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _senhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
              ),
              validator: (value) {
                if (value == null || value.length < 8) {
                  return 'A senha deve ter pelo menos 8 caracteres.';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: state.carregando ? null : _entrar,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: state.carregando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Entrar'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: state.carregando ? null : () => context.go(AppRoutes.entrada),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
