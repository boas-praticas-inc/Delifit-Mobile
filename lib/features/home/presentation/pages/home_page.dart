import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/core/di/providers.dart';
import '../../../endereco/domain/entities/endereco.dart';
import '../../../restaurante/domain/entities/restaurante.dart';
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
    Future.microtask(() => ref.read(perfilClienteControllerProvider).carregar());
    Future.microtask(() => ref.read(enderecosControllerProvider).carregar());
  }

  @override
  Widget build(BuildContext context) {
    final restaurantesState = ref.watch(homeRestaurantesControllerProvider).state;
    final enderecosState = ref.watch(enderecosControllerProvider).state;
    final restaurantes = restaurantesState.filtrados;
    final enderecoPrincipal = _obterEnderecoPrincipal(enderecosState.enderecos);
    final tituloEntrega = _tituloEntrega(enderecoPrincipal);
    final subtituloEntrega = _subtituloEntrega(enderecoPrincipal);

    return ClienteNavScaffold(
      indiceAtual: 0,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF2E7D32),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(Icons.location_on_outlined, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Entrega em',
                            style: TextStyle(
                              color: Color(0xFFDCEBD6),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tituloEntrega,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtituloEntrega,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFDCEBD6),
                              fontSize: 13,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const CircleAvatar(
                      backgroundColor: Color(0x2EFFFFFF),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: ref.read(homeRestaurantesControllerProvider).atualizarFiltro,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar restaurantes ou refeições',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(999),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: const [
                _CategoriaBubble(titulo: 'Ver tudo', icone: Icons.grid_view_rounded),
                _CategoriaBubble(titulo: 'Ofertas', icone: Icons.local_offer_outlined),
                _CategoriaBubble(titulo: 'Fitness', icone: Icons.fitness_center_outlined),
                _CategoriaBubble(titulo: 'Refeições', icone: Icons.restaurant_menu_outlined),
              ],
            ),
          ),
          _Section(
            titulo: 'Restaurantes com fit e saudável',
            child: restaurantesState.carregando
                ? const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : restaurantesState.erro != null
                    ? Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Text(restaurantesState.erro!),
                        ),
                      )
                    : _RestauranteList(restaurantes: restaurantes),
          ),
          _Section(
            titulo: 'Refeições recentes',
            child: _RestauranteList(restaurantes: restaurantes.take(4).toList()),
          ),
          _Section(
            titulo: 'Refeições em destaque',
            child: _DestaqueList(restaurantes: restaurantes.take(2).toList()),
          ),
          const SizedBox(height: 28),
        ],
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

class _Section extends StatelessWidget {
  const _Section({required this.titulo, required this.child});

  final String titulo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _CategoriaBubble extends StatelessWidget {
  const _CategoriaBubble({required this.titulo, required this.icone});

  final String titulo;
  final IconData icone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: const Color(0xFFE8F3E2),
            child: Icon(icone, color: const Color(0xFF2E7D32)),
          ),
          const SizedBox(height: 10),
          Text(titulo),
        ],
      ),
    );
  }
}

class _RestauranteList extends StatelessWidget {
  const _RestauranteList({required this.restaurantes});

  final List<Restaurante> restaurantes;

  @override
  Widget build(BuildContext context) {
    if (restaurantes.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Text('Nenhum restaurante encontrado no momento.'),
        ),
      );
    }

    return SizedBox(
      height: 196,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: restaurantes.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final restaurante = restaurantes[index];
          return SizedBox(
            width: 230,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 74,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3E2),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.lunch_dining_outlined,
                          size: 36,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      restaurante.nomeFantasia,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        restaurante.descricao ??
                            'Culinária fit pronta para o dia a dia.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DestaqueList extends StatelessWidget {
  const _DestaqueList({required this.restaurantes});

  final List<Restaurante> restaurantes;

  @override
  Widget build(BuildContext context) {
    if (restaurantes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: restaurantes.map((restaurante) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFFE8F3E2),
                child: Icon(Icons.restaurant, color: Color(0xFF2E7D32)),
              ),
              title: Text(restaurante.nomeFantasia),
              subtitle: Text(restaurante.telefone),
            ),
          ),
        );
      }).toList(),
    );
  }
}

