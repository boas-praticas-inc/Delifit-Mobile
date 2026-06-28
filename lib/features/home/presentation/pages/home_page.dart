import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/core/di/providers.dart';
import '../../../../app/routes/app_routes.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessao = ref.watch(authControllerProvider).state.sessao;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(authControllerProvider).sair();
              if (context.mounted) {
                context.go(AppRoutes.entrada);
              }
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bem-vindo, ${sessao?.nomeCompleto ?? 'cliente'}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Seu acesso autenticado ja esta pronto. As proximas etapas naturais sao perfil, enderecos, cartoes e pedidos.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _FeatureTile(
            titulo: 'Perfil do cliente',
            descricao: 'Dados pessoais, ajustes da conta e historico basico.',
          ),
          const SizedBox(height: 12),
          const _FeatureTile(
            titulo: 'Enderecos',
            descricao: 'Gerencie seus enderecos de entrega com a API ja pronta.',
          ),
          const SizedBox(height: 12),
          const _FeatureTile(
            titulo: 'Cartoes',
            descricao: 'Fluxo futuro para manter cartoes e pagamento.',
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.titulo, required this.descricao});

  final String titulo;
  final String descricao;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(titulo),
        subtitle: Text(descricao),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
