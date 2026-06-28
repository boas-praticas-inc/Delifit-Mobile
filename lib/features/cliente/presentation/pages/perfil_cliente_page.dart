import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../app/core/di/providers.dart';
import '../../../../app/core/utils/text_sanitizer.dart';

class PerfilClientePage extends ConsumerStatefulWidget {
  const PerfilClientePage({super.key});

  @override
  ConsumerState<PerfilClientePage> createState() => _PerfilClientePageState();
}

class _PerfilClientePageState extends ConsumerState<PerfilClientePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');
  final _telefoneMask = MaskTextInputFormatter(mask: '(##) #####-####');
  DateTime? _dataNascimento;
  bool _preenchido = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(perfilClienteControllerProvider).carregar());
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _dataNascimentoController.dispose();
    super.dispose();
  }

  void _preencherSeNecessario() {
    final perfil = ref.read(perfilClienteControllerProvider).state.perfil;
    if (_preenchido || perfil == null) {
      return;
    }
    _nomeController.text = perfil.nomeCompleto;
    _cpfController.text = perfil.cpf;
    _telefoneController.text = perfil.telefone ?? '';
    if (perfil.dataNascimento != null) {
      _dataNascimento = DateTime.tryParse(perfil.dataNascimento!);
      if (_dataNascimento != null) {
        _dataNascimentoController.text = DateFormat('dd/MM/yyyy').format(_dataNascimento!);
      }
    }
    _preenchido = true;
  }

  Future<void> _selecionarData() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataNascimento ?? DateTime(now.year - 18, now.month, now.day),
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

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final ok = await ref.read(perfilClienteControllerProvider).salvar(
          nomeCompleto: _nomeController.text.trim(),
          cpf: TextSanitizer.apenasDigitos(_cpfController.text),
          telefone: TextSanitizer.apenasDigitos(_telefoneController.text),
          dataNascimento: _dataNascimento,
        );

    if (!mounted) return;

    final mensagem = ok
        ? 'Perfil atualizado com sucesso.'
        : ref.read(perfilClienteControllerProvider).state.erro;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem ?? 'Não foi possível salvar.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(perfilClienteControllerProvider).state;
    _preencherSeNecessario();

    return Scaffold(
      appBar: AppBar(title: const Text('Dados pessoais')),
      body: state.carregando && state.perfil == null
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(labelText: 'Nome completo'),
                    validator: (value) => value == null || value.trim().length < 3
                        ? 'Informe seu nome completo.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cpfController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [_cpfMask],
                    decoration: const InputDecoration(labelText: 'CPF'),
                    validator: (value) => value == null || TextSanitizer.apenasDigitos(value).length != 11
                        ? 'Informe um CPF válido.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _telefoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [_telefoneMask],
                    decoration: const InputDecoration(labelText: 'Celular'),
                    validator: (value) => value == null || TextSanitizer.apenasDigitos(value).length < 10
                        ? 'Informe um celular válido.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dataNascimentoController,
                    readOnly: true,
                    onTap: _selecionarData,
                    decoration: const InputDecoration(labelText: 'Data de nascimento'),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: state.salvando ? null : _salvar,
                    child: state.salvando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Salvar alterações'),
                  ),
                ],
              ),
            ),
    );
  }
}

