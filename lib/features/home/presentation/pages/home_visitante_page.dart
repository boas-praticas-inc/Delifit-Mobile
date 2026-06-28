import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/core/di/providers.dart';
import '../../../../app/routes/app_routes.dart';

class HomeVisitantePage extends ConsumerWidget {
  const HomeVisitantePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorar como visitante'),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(authControllerProvider).sair();
              if (context.mounted) {
                context.go(AppRoutes.entrada);
              }
            },
            child: const Text('Sair'),
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
                    'Modo visitante ativo',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Voce pode conhecer a experiencia inicial do app, mas recursos como endereco, cartoes e perfil vao pedir autenticacao.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => context.go(AppRoutes.login),
            child: const Text('Entrar agora'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.go(AppRoutes.cadastro),
            child: const Text('Criar conta'),
          ),
        ],
      ),
    );
  }
}
