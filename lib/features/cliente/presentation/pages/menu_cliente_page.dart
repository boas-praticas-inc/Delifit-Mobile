import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/core/di/providers.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../shared/presentation/widgets/cliente_nav_scaffold.dart';

class MenuClientePage extends ConsumerStatefulWidget {
  const MenuClientePage({super.key});

  @override
  ConsumerState<MenuClientePage> createState() => _MenuClientePageState();
}

class _MenuClientePageState extends ConsumerState<MenuClientePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(perfilClienteControllerProvider).carregar());
  }

  @override
  Widget build(BuildContext context) {
    final perfilState = ref.watch(perfilClienteControllerProvider).state;
    final perfil = perfilState.perfil;

    return ClienteNavScaffold(
      indiceAtual: 3,
      appBar: AppBar(title: const Text('Menu do cliente')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 46,
                    backgroundColor: Color(0xFFE5F1E1),
                    child: Icon(Icons.person, size: 44, color: Color(0xFF2E7D32)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    perfil?.nomeCompleto ?? 'Cliente Delifit',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    perfil?.telefone ?? 'Telefone não carregado',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _MenuCard(
            icone: Icons.badge_outlined,
            titulo: 'Dados pessoais',
            descricao: 'Edite nome, CPF, celular e data de nascimento.',
            onTap: () => context.push(AppRoutes.perfil),
          ),
          const SizedBox(height: 12),
          _MenuCard(
            icone: Icons.location_on_outlined,
            titulo: 'Endereços',
            descricao: 'Gerencie seus endereços de entrega cadastrados.',
            onTap: () => context.push(AppRoutes.enderecos),
          ),
          const SizedBox(height: 12),
          _MenuCard(
            icone: Icons.credit_card_outlined,
            titulo: 'Formas de pagamento',
            descricao: 'Consulte e mantenha seus cartões salvos.',
            onTap: () => context.push(AppRoutes.cartoes),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(authControllerProvider).sair();
              if (context.mounted) {
                context.go(AppRoutes.entrada);
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sair da conta'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Exclusão de conta ainda não está disponível na API atual.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.icone,
    required this.titulo,
    required this.descricao,
    required this.onTap,
  });

  final IconData icone;
  final String titulo;
  final String descricao;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE8F3E2),
          child: Icon(icone, color: const Color(0xFF2E7D32)),
        ),
        title: Text(titulo),
        subtitle: Text(descricao),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

