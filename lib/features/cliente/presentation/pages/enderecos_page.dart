import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../app/core/di/providers.dart';
import '../../../../app/core/utils/text_sanitizer.dart';
import '../../../endereco/domain/entities/endereco.dart';

class EnderecosPage extends ConsumerStatefulWidget {
  const EnderecosPage({super.key});

  @override
  ConsumerState<EnderecosPage> createState() => _EnderecosPageState();
}

class _EnderecosPageState extends ConsumerState<EnderecosPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(enderecosControllerProvider).carregar());
  }

  Future<void> _abrirFormulario([Endereco? endereco]) async {
    final controller = ref.read(enderecosControllerProvider);
    final formKey = GlobalKey<FormState>();
    final cepController = TextEditingController(text: endereco?.cep ?? '');
    final logradouroController = TextEditingController(text: endereco?.logradouro ?? '');
    final numeroController = TextEditingController(text: endereco?.numero ?? '');
    final bairroController = TextEditingController(text: endereco?.bairro ?? '');
    final cidadeController = TextEditingController(text: endereco?.cidade ?? '');
    final estadoController = TextEditingController(text: endereco?.estado ?? 'SP');
    final complementoController = TextEditingController(text: endereco?.complemento ?? '');
    final referenciaController = TextEditingController(text: endereco?.referencia ?? '');
    final labelController = TextEditingController(text: endereco?.label ?? 'Principal');
    final cepMask = MaskTextInputFormatter(mask: '#####-###');

    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    endereco == null ? 'Novo endereço' : 'Editar endereço',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: cepController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [cepMask],
                    decoration: const InputDecoration(labelText: 'CEP'),
                    validator: (value) => value == null || TextSanitizer.apenasDigitos(value).length != 8
                        ? 'Informe um CEP válido.'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: logradouroController,
                    decoration: const InputDecoration(labelText: 'Logradouro'),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Informe o logradouro.'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: numeroController,
                    decoration: const InputDecoration(labelText: 'Número'),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Informe o número.'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: bairroController,
                    decoration: const InputDecoration(labelText: 'Bairro'),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Informe o bairro.'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: cidadeController,
                    decoration: const InputDecoration(labelText: 'Cidade'),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Informe a cidade.'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: estadoController,
                    decoration: const InputDecoration(labelText: 'UF'),
                    validator: (v) => v == null || v.trim().length != 2
                        ? 'UF inválida.'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: complementoController,
                    decoration: const InputDecoration(labelText: 'Complemento'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: referenciaController,
                    decoration: const InputDecoration(labelText: 'Referência'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: labelController,
                    decoration: const InputDecoration(labelText: 'Identificação'),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final salvo = await controller.salvar(
                        enderecoId: endereco?.id,
                        cep: TextSanitizer.apenasDigitos(cepController.text),
                        logradouro: logradouroController.text.trim(),
                        numero: numeroController.text.trim(),
                        bairro: bairroController.text.trim(),
                        cidade: cidadeController.text.trim(),
                        estado: estadoController.text.trim().toUpperCase(),
                        complemento: complementoController.text.trim().isEmpty
                            ? null
                            : complementoController.text.trim(),
                        referencia: referenciaController.text.trim().isEmpty
                            ? null
                            : referenciaController.text.trim(),
                        label: labelController.text.trim().isEmpty
                            ? null
                            : labelController.text.trim(),
                      );
                      if (context.mounted) Navigator.of(context).pop(salvo);
                    },
                    child: const Text('Salvar endereço'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (!mounted) return;
    if (ok == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Endereço salvo com sucesso.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(enderecosControllerProvider).state;

    return Scaffold(
      appBar: AppBar(title: const Text('Endereços')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
      body: state.carregando
          ? const Center(child: CircularProgressIndicator())
          : state.enderecos.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Nenhum endereço cadastrado até o momento.'),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: state.enderecos.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final endereco = state.enderecos[index];
                    return Card(
                      child: ListTile(
                        title: Text(endereco.label ?? 'Endereço ${index + 1}'),
                        subtitle: Text(
                          '${endereco.logradouro}, ${endereco.numero} • ${endereco.bairro} • ${endereco.cidade}/${endereco.estado}',
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'editar') {
                              await _abrirFormulario(endereco);
                            } else {
                              await ref.read(enderecosControllerProvider).excluir(endereco.id);
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'editar', child: Text('Editar')),
                            PopupMenuItem(value: 'excluir', child: Text('Excluir')),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

