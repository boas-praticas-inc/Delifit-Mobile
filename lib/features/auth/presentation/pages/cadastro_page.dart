import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../app/core/di/providers.dart';
import '../../../../app/core/utils/text_sanitizer.dart';
import '../../../../app/routes/app_routes.dart';
import '../widgets/auth_scaffold.dart';

class CadastroPage extends ConsumerStatefulWidget {
  const CadastroPage({super.key});

  @override
  ConsumerState<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends ConsumerState<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmacaoSenhaController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');
  final _telefoneMask = MaskTextInputFormatter(mask: '(##) #####-####');
  DateTime? _dataNascimento;

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _confirmacaoSenhaController.dispose();
    _dataNascimentoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        _dataNascimento = picked;
        _dataNascimentoController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(authControllerProvider).registrarCliente(
            telefone: TextSanitizer.apenasDigitos(_telefoneController.text),
            senha: _senhaController.text,
            nomeCompleto: _nomeController.text.trim(),
            cpf: TextSanitizer.apenasDigitos(_cpfController.text),
            dataNascimento: _dataNascimento,
          );
    } catch (_) {
      final mensagem = ref.read(authControllerProvider).state.mensagemErro;
      messenger.showSnackBar(
        SnackBar(content: Text(mensagem ?? 'Não foi possível criar a conta.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider).state;

    return AuthScaffold(
      title: 'Crie sua conta',
      subtitle: 'Vamos cadastrar seus dados e depois pedir seu endereço principal.',
      footer: TextButton(
        onPressed: state.carregando ? null : () => context.go(AppRoutes.login),
        child: const Text('Já possui conta? Fazer login'),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nomeController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Nome completo'),
              validator: (value) {
                if (value == null || value.trim().length < 3) {
                  return 'Informe seu nome completo.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cpfController,
              keyboardType: TextInputType.number,
              inputFormatters: [_cpfMask],
              decoration: const InputDecoration(labelText: 'CPF'),
              validator: (value) {
                if (value == null || TextSanitizer.apenasDigitos(value).length != 11) {
                  return 'Informe um CPF válido.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _telefoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [_telefoneMask],
              decoration: const InputDecoration(labelText: 'Celular'),
              validator: (value) {
                if (value == null || TextSanitizer.apenasDigitos(value).length < 10) {
                  return 'Informe um celular válido.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dataNascimentoController,
              readOnly: true,
              onTap: _selecionarData,
              decoration: const InputDecoration(
                labelText: 'Data de nascimento',
                hintText: 'Opcional',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
              validator: (value) {
                if (value == null || value.length < 8) {
                  return 'A senha deve ter pelo menos 8 caracteres.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmacaoSenhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirmar senha'),
              validator: (value) {
                if (value != _senhaController.text) {
                  return 'As senhas precisam ser iguais.';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: state.carregando ? null : _cadastrar,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: state.carregando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Criar conta'),
            ),
          ],
        ),
      ),
    );
  }
}

