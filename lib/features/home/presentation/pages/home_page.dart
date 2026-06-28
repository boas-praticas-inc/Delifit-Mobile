import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/core/di/providers.dart';
import '../../../endereco/domain/entities/endereco.dart';
import '../widgets/home_catalogo_content.dart';
import '../../../shared/presentation/widgets/cliente_nav_scaffold.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(homeRestaurantesControllerProvider).carregar());
    Future.microtask(() => ref.read(homeItensCardapioControllerProvider).carregar());
    Future.microtask(() => ref.read(perfilClienteControllerProvider).carregar());
    Future.microtask(() => ref.read(enderecosControllerProvider).carregar());
  }

  void _atualizarPesquisa(String value) {
    ref.read(homeRestaurantesControllerProvider).atualizarFiltro(value);
    ref.read(homeItensCardapioControllerProvider).atualizarFiltro(value);
  }

  @override
  Widget build(BuildContext context) {
    final restaurantesState = ref.watch(homeRestaurantesControllerProvider).state;
    final itensState = ref.watch(homeItensCardapioControllerProvider).state;
    final enderecosState = ref.watch(enderecosControllerProvider).state;
    final enderecoPrincipal = _obterEnderecoPrincipal(enderecosState.enderecos);

    return ClienteNavScaffold(
      indiceAtual: 0,
      body: HomeCatalogoContent(
        tituloEntrega: _tituloEntrega(enderecoPrincipal),
        subtituloEntrega: _subtituloEntrega(enderecoPrincipal),
        restaurantesState: restaurantesState,
        itensState: itensState,
        onPesquisar: _atualizarPesquisa,
      ),
    );
  }
}

Endereco? _obterEnderecoPrincipal(List<Endereco> enderecos) {
  for (final endereco in enderecos) {
    final label = endereco.label?.trim().toLowerCase();
    if (label == 'principal' || label == 'padrão' || label == 'padrao') {
      return endereco;
    }
  }

  if (enderecos.isEmpty) {
    return null;
  }

  return enderecos.first;
}

String _tituloEntrega(Endereco? endereco) {
  if (endereco == null) {
    return 'Cadastre seu endereço';
  }

  return '${endereco.logradouro}, ${endereco.numero}';
}

String _subtituloEntrega(Endereco? endereco) {
  if (endereco == null) {
    return 'Adicione um endereço para agilizar seu primeiro pedido.';
  }

  return '${endereco.bairro} • ${endereco.cidade}/${endereco.estado}';
}
