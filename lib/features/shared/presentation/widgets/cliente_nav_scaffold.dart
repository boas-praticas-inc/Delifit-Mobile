import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/app_routes.dart';

class ClienteNavScaffold extends StatelessWidget {
  const ClienteNavScaffold({
    super.key,
    required this.indiceAtual,
    required this.body,
    this.appBar,
    this.floatingActionButton,
  });

  final int indiceAtual;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  void _onTap(BuildContext context, int index) {
    const routes = <String>[
      AppRoutes.home,
      AppRoutes.pedidos,
      AppRoutes.consumo,
      AppRoutes.menu,
    ];
    context.go(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: NavigationBar(
        selectedIndex: indiceAtual,
        onDestinationSelected: (index) => _onTap(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Pedidos',
          ),
          NavigationDestination(
            icon: Icon(Icons.spa_outlined),
            selectedIcon: Icon(Icons.spa),
            label: 'Consumo',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_outlined),
            selectedIcon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}

