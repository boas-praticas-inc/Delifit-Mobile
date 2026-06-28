import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/core/di/providers.dart';
import '../../../../app/routes/app_routes.dart';

class HomeVisitantePage extends ConsumerStatefulWidget {
  const HomeVisitantePage({super.key});

  @override
  ConsumerState<HomeVisitantePage> createState() => _HomeVisitantePageState();
}

class _HomeVisitantePageState extends ConsumerState<HomeVisitantePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(homeRestaurantesControllerProvider).carregar());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeRestaurantesControllerProvider).state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorar Delifit'),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(authControllerProvider).sair();
              if (context.mounted) context.go(AppRoutes.entrada);
            },
            child: const Text('Sair'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Modo visitante ativo. Conheça os restaurantes e faça login para salvar endereços, cartões e acompanhar seus pedidos.',
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (state.carregando)
            const Center(child: CircularProgressIndicator())
          else if (state.erro != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(state.erro!),
              ),
            )
          else
            ...state.restaurantes.map(
              (restaurante) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.restaurant)),
                    title: Text(restaurante.nomeFantasia),
                    subtitle: Text(
                      restaurante.descricao ?? 'Restaurante parceiro Delifit',
                    ),
                  ),
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

