import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../app/core/di/providers.dart';
import '../../../../app/core/utils/text_sanitizer.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../auth/presentation/widgets/auth_scaffold.dart';

class CadastroEnderecoPage extends ConsumerStatefulWidget {
  const CadastroEnderecoPage({super.key});

  @override
  ConsumerState<CadastroEnderecoPage> createState() => _CadastroEnderecoPageState();
}

class _CadastroEnderecoPageState extends ConsumerState<CadastroEnderecoPage> {
  final _formKey = GlobalKey<FormState>();
  final _cepController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController(text: 'SP');
  final _complementoController = TextEditingController();
  final _referenciaController = TextEditingController();
  final _labelController = TextEditingController(text: 'Principal');
  final _cepMask = MaskTextInputFormatter(mask: '#####-###');

  @override
  void dispose() {
    _cepController.dispose();
    _logradouroController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _complementoController.dispose();
    _referenciaController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(cadastroEnderecoControllerProvider).criarEnderecoInicial(
            cep: TextSanitizer.apenasDigitos(_cepController.text),
            logradouro: _logradouroController.text.trim(),
            numero: _numeroController.text.trim(),
            bairro: _bairroController.text.trim(),
            cidade: _cidadeController.text.trim(),
            estado: _estadoController.text.trim().toUpperCase(),
            complemento: _complementoController.text.trim().isEmpty
                ? null
                : _complementoController.text.trim(),
            referencia: _referenciaController.text.trim().isEmpty
                ? null
                : _referenciaController.text.trim(),
            label: _labelController.text.trim().isEmpty
                ? 'Principal'
                : _labelController.text.trim(),
          );
      ref.read(authControllerProvider).concluirCadastroEnderecoInicial();
      if (mounted) {
        context.go(AppRoutes.home);
      }
    } catch (_) {
      final mensagem = ref.read(cadastroEnderecoControllerProvider).state.mensagemErro;
      messenger.showSnackBar(
        SnackBar(content: Text(mensagem ?? 'Não foi possível salvar o endereço.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cadastroEnderecoControllerProvider).state;

    return AuthScaffold(
      title: 'Seu endereço principal',
      subtitle:
          'Esse passo pode ser pulado agora, mas ajuda a deixar a experiência pronta para o primeiro pedido.',
      footer: TextButton(
        onPressed: state.carregando
            ? null
            : () {
                ref.read(authControllerProvider).concluirCadastroEnderecoInicial();
                context.go(AppRoutes.home);
              },
        child: const Text('Pular por agora'),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              inputFormatters: [_cepMask],
              decoration: const InputDecoration(labelText: 'CEP'),
              validator: (value) {
                if (value == null || TextSanitizer.apenasDigitos(value).length != 8) {
                  return 'Informe um CEP válido.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _logradouroController,
              decoration: const InputDecoration(labelText: 'Logradouro'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Informe o logradouro.'
                  : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _numeroController,
                    decoration: const InputDecoration(labelText: 'Número'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Informe o número.'
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _estadoController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(labelText: 'UF'),
                    validator: (value) => value == null || value.trim().length != 2
                        ? 'UF inválida.'
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bairroController,
              decoration: const InputDecoration(labelText: 'Bairro'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Informe o bairro.'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cidadeController,
              decoration: const InputDecoration(labelText: 'Cidade'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Informe a cidade.'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _complementoController,
              decoration: const InputDecoration(labelText: 'Complemento'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _referenciaController,
              decoration: const InputDecoration(labelText: 'Referência'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _labelController,
              decoration: const InputDecoration(labelText: 'Identificação do endereço'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: state.carregando ? null : _salvar,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: state.carregando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Salvar endereço e continuar'),
            ),
          ],
        ),
      ),
    );
  }
}

