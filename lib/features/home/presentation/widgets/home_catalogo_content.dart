import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../item_cardapio/domain/entities/item_cardapio.dart';
import '../../../restaurante/domain/entities/restaurante.dart';
import '../../../item_cardapio/presentation/controllers/home_itens_cardapio_state.dart';
import '../../../restaurante/presentation/controllers/home_restaurantes_state.dart';

class HomeCatalogoContent extends StatelessWidget {
  const HomeCatalogoContent({
    super.key,
    required this.tituloEntrega,
    required this.subtituloEntrega,
    required this.restaurantesState,
    required this.itensState,
    required this.onPesquisar,
    this.visitante = false,
    this.onEntrar,
    this.onCadastrar,
  });

  final String tituloEntrega;
  final String subtituloEntrega;
  final HomeRestaurantesState restaurantesState;
  final HomeItensCardapioState itensState;
  final ValueChanged<String> onPesquisar;
  final bool visitante;
  final VoidCallback? onEntrar;
  final VoidCallback? onCadastrar;

  @override
  Widget build(BuildContext context) {
    final restaurantes = restaurantesState.filtrados;
    final mapaRestaurantes = {
      for (final restaurante in restaurantesState.restaurantes)
        restaurante.id: restaurante.nomeFantasia,
    };

    final itensRecentes = [...itensState.filtrados]
      ..sort((a, b) => b.criadoEm.compareTo(a.criadoEm));

    final itensDestaqueBase = itensState.filtrados.where((item) => item.tags.isNotEmpty).toList();
    final itensDestaque = itensDestaqueBase.isNotEmpty
        ? itensDestaqueBase
        : itensState.filtrados;

    return ListView(
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
                          maxLines: 2,
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
                onChanged: onPesquisar,
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
        if (visitante)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exploração liberada para visitantes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Você pode navegar pelo catálogo normalmente. Quando o fluxo de pedidos for liberado, será necessário criar uma conta ou entrar para concluir a compra.',
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: onEntrar,
                            child: const Text('Entrar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: onCadastrar,
                            child: const Text('Criar conta'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
          child: itensState.carregando
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                )
              : itensState.erro != null
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Text(itensState.erro!),
                      ),
                    )
                  : _ItemCardapioList(
                      itens: itensRecentes.take(6).toList(),
                      mapaRestaurantes: mapaRestaurantes,
                    ),
        ),
        _Section(
          titulo: 'Refeições em destaque',
          child: _ItemCardapioDestaqueList(
            itens: itensDestaque.take(4).toList(),
            mapaRestaurantes: mapaRestaurantes,
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
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
                          Icons.storefront_outlined,
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
                            'Restaurante parceiro com opções pensadas para o dia a dia.',
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

class _ItemCardapioList extends StatelessWidget {
  const _ItemCardapioList({required this.itens, required this.mapaRestaurantes});

  final List<ItemCardapio> itens;
  final Map<int, String> mapaRestaurantes;

  @override
  Widget build(BuildContext context) {
    if (itens.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Text('Nenhuma refeição encontrada no momento.'),
        ),
      );
    }

    return SizedBox(
      height: 208,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itens.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = itens[index];
          final restauranteNome = mapaRestaurantes[item.restauranteId] ?? 'Restaurante parceiro';
          final variacao = item.variacaoPrincipal;
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
                      item.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      restauranteNome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        item.descricao ?? 'Refeição disponível no cardápio do restaurante.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatarPreco(variacao?.preco),
                      style: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w700,
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

class _ItemCardapioDestaqueList extends StatelessWidget {
  const _ItemCardapioDestaqueList({required this.itens, required this.mapaRestaurantes});

  final List<ItemCardapio> itens;
  final Map<int, String> mapaRestaurantes;

  @override
  Widget build(BuildContext context) {
    if (itens.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Text('Nenhuma refeição em destaque no momento.'),
        ),
      );
    }

    return Column(
      children: itens.map((item) {
        final variacao = item.variacaoPrincipal;
        final restauranteNome = mapaRestaurantes[item.restauranteId] ?? 'Restaurante parceiro';
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFFE8F3E2),
                child: Icon(Icons.restaurant_menu, color: Color(0xFF2E7D32)),
              ),
              title: Text(item.nome),
              subtitle: Text(
                '$restauranteNome • ${_formatarPreco(variacao?.preco)}',
              ),
              trailing: variacao == null
                  ? null
                  : Text('${variacao.caloria.toStringAsFixed(0)} kcal'),
            ),
          ),
        );
      }).toList(),
    );
  }
}

String _formatarPreco(double? preco) {
  if (preco == null) {
    return 'Consulte';
  }

  return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(preco);
}
