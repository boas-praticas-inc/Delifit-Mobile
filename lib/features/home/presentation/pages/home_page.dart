import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delifit Mobile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          _IntroCard(),
          SizedBox(height: 16),
          _ModuleCard(
            titulo: 'Auth',
            descricao: 'Cadastro, login, sessao e protecao de rotas.',
          ),
          SizedBox(height: 12),
          _ModuleCard(
            titulo: 'Enderecos',
            descricao: 'Fluxo para listar, criar, editar e remover enderecos.',
          ),
          SizedBox(height: 12),
          _ModuleCard(
            titulo: 'Cartoes',
            descricao: 'Fluxo para manter cartoes salvos do cliente.',
          ),
        ],
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Base pronta para evoluir',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'O projeto ja esta com Flutter, Riverpod, GoRouter, Dio e a estrutura inicial para comecarmos as features do cliente.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.titulo,
    required this.descricao,
  });

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
