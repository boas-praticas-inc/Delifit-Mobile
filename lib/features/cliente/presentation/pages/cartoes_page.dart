import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/core/di/providers.dart';
import '../../../../app/core/utils/text_sanitizer.dart';
import '../../domain/entities/cartao_cliente.dart';

class CartoesPage extends ConsumerStatefulWidget {
  const CartoesPage({super.key});

  @override
  ConsumerState<CartoesPage> createState() => _CartoesPageState();
}

class _CartoesPageState extends ConsumerState<CartoesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(cartoesControllerProvider).carregar());
  }

  Future<void> _abrirFormulario([CartaoCliente? cartao]) async {
    final controller = ref.read(cartoesControllerProvider);
    final formKey = GlobalKey<FormState>();
    final nomeController = TextEditingController(text: cartao?.nomeTitular ?? '');
    final ultimosController = TextEditingController(text: cartao?.ultimosQuatroDigitos ?? '');
    final bandeiraController = TextEditingController(text: cartao?.bandeira ?? '');
    bool padrao = cartao?.padrao ?? false;

    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                        cartao == null ? 'Novo cartão' : 'Editar cartão',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: nomeController,
                        decoration: const InputDecoration(labelText: 'Nome do titular'),
                        validator: (value) => value == null || value.trim().isEmpty
                            ? 'Informe o nome do titular.'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: ultimosController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Últimos 4 dígitos'),
                        validator: (value) => value == null || TextSanitizer.apenasDigitos(value).length != 4
                            ? 'Informe 4 dígitos.'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: bandeiraController,
                        decoration: const InputDecoration(labelText: 'Bandeira'),
                        validator: (value) => value == null || value.trim().isEmpty
                            ? 'Informe a bandeira.'
                            : null,
                      ),
                      SwitchListTile(
                        value: padrao,
                        onChanged: (value) => setModalState(() => padrao = value),
                        title: const Text('Definir como principal'),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          final salvo = await controller.salvar(
                            cartaoId: cartao?.id,
                            nomeTitular: nomeController.text.trim(),
                            ultimosQuatroDigitos: TextSanitizer.apenasDigitos(ultimosController.text),
                            bandeira: bandeiraController.text.trim().toUpperCase(),
                            padrao: padrao,
                            tokenGateway: null,
                          );
                          if (context.mounted) Navigator.of(context).pop(salvo);
                        },
                        child: const Text('Salvar cartão'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (!mounted) return;
    if (ok == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cartão salvo com sucesso.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cartoesControllerProvider).state;

    return Scaffold(
      appBar: AppBar(title: const Text('Formas de pagamento')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add_card),
        label: const Text('Novo'),
      ),
      body: state.carregando
          ? const Center(child: CircularProgressIndicator())
          : state.cartoes.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Nenhum cartão cadastrado até o momento.'),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: state.cartoes.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final cartao = state.cartoes[index];
                    return Card(
                      child: ListTile(
                        title: Text('${cartao.bandeira} •••• ${cartao.ultimosQuatroDigitos}'),
                        subtitle: Text(
                          '${cartao.nomeTitular}${cartao.padrao ? ' • Principal' : ''}',
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'editar') {
                              await _abrirFormulario(cartao);
                            } else {
                              await ref.read(cartoesControllerProvider).excluir(cartao.id);
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

