import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/core/di/providers.dart';
import '../../../../app/routes/app_routes.dart';
import '../widgets/auth_scaffold.dart';

class EntradaPage extends ConsumerWidget {
  const EntradaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider);
    final loading = authController.state.carregando;

    return AuthScaffold(
      title: 'Seu delivery fitness, sem atrito',
      subtitle:
          'Entre com seu celular, crie sua conta ou experimente o app como visitante.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Escolha como deseja continuar',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const Text(
            'Voce pode navegar como visitante e criar sua conta quando quiser.',
            style: TextStyle(height: 1.5),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: loading ? null : () => context.go(AppRoutes.login),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Entrar com celular'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: loading ? null : () => context.go(AppRoutes.cadastro),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Criar conta'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: loading
                ? null
                : () async {
                    await ref.read(authControllerProvider).entrarComoVisitante();
                  },
            child: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Entrar como visitante'),
          ),
        ],
      ),
    );
  }
}
