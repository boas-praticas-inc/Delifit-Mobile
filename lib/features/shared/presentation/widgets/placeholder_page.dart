import 'package:flutter/material.dart';

import 'cliente_nav_scaffold.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    super.key,
    required this.indiceAtual,
    required this.titulo,
    required this.mensagem,
  });

  final int indiceAtual;
  final String titulo;
  final String mensagem;

  @override
  Widget build(BuildContext context) {
    return ClienteNavScaffold(
      indiceAtual: indiceAtual,
      appBar: AppBar(title: Text(titulo)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.schedule, size: 52),
                  const SizedBox(height: 12),
                  Text(
                    titulo,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mensagem,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

