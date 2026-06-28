import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/core/di/providers.dart';
import '../../../../app/routes/app_routes.dart';
import '../widgets/home_catalogo_content.dart';

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
    Future.microtask(() => ref.read(homeItensCardapioControllerProvider).carregar());
  }

  void _atualizarPesquisa(String value) {
    ref.read(homeRestaurantesControllerProvider).atualizarFiltro(value);
    ref.read(homeItensCardapioControllerProvider).atualizarFiltro(value);
  }

  @override
  Widget build(BuildContext context) {
    final restaurantesState = ref.watch(homeRestaurantesControllerProvider).state;
    final itensState = ref.watch(homeItensCardapioControllerProvider).state;

    return Scaffold(
      body: SafeArea(
        child: HomeCatalogoContent(
          tituloEntrega: 'Sua região',
          subtituloEntrega:
              'Entre para salvar endereço e concluir pedidos quando esse fluxo estiver disponível.',
          restaurantesState: restaurantesState,
          itensState: itensState,
          onPesquisar: _atualizarPesquisa,
          visitante: true,
          onEntrar: () => context.go(AppRoutes.login),
          onCadastrar: () => context.go(AppRoutes.cadastro),
        ),
      ),
    );
  }
}
