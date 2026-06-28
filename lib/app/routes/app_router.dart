import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/controllers/auth_state.dart';
import '../../features/auth/presentation/pages/cadastro_page.dart';
import '../../features/auth/presentation/pages/entrada_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/cliente/presentation/pages/cartoes_page.dart';
import '../../features/cliente/presentation/pages/enderecos_page.dart';
import '../../features/cliente/presentation/pages/menu_cliente_page.dart';
import '../../features/cliente/presentation/pages/perfil_cliente_page.dart';
import '../../features/endereco/presentation/pages/cadastro_endereco_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/home_visitante_page.dart';
import '../../features/shared/presentation/widgets/placeholder_page.dart';
import 'app_routes.dart';

GoRouter buildRouter(AuthController authController) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: authController,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.entrada,
        builder: (context, state) => const EntradaPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.cadastro,
        builder: (context, state) => const CadastroPage(),
      ),
      GoRoute(
        path: AppRoutes.cadastroEndereco,
        builder: (context, state) => const CadastroEnderecoPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.pedidos,
        builder: (context, state) => const PlaceholderPage(
          indiceAtual: 1,
          titulo: 'Pedidos',
          mensagem:
              'Aqui vamos listar os pedidos do cliente nas próximas etapas.',
        ),
      ),
      GoRoute(
        path: AppRoutes.consumo,
        builder: (context, state) => const PlaceholderPage(
          indiceAtual: 2,
          titulo: 'Consumo',
          mensagem:
              'Aqui vamos organizar o consumo e os planos do cliente nas próximas etapas.',
        ),
      ),
      GoRoute(
        path: AppRoutes.menu,
        builder: (context, state) => const MenuClientePage(),
      ),
      GoRoute(
        path: AppRoutes.perfil,
        builder: (context, state) => const PerfilClientePage(),
      ),
      GoRoute(
        path: AppRoutes.enderecos,
        builder: (context, state) => const EnderecosPage(),
      ),
      GoRoute(
        path: AppRoutes.cartoes,
        builder: (context, state) => const CartoesPage(),
      ),
      GoRoute(
        path: AppRoutes.visitante,
        builder: (context, state) => const HomeVisitantePage(),
      ),
    ],
    redirect: (context, state) {
      final authState = authController.state;
      final location = state.matchedLocation;

      if (authState.status == AuthStatus.inicializando) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      if (authState.visitante) {
        return location == AppRoutes.visitante ? null : AppRoutes.visitante;
      }

      if (authState.autenticado && authState.precisaCompletarEnderecoInicial) {
        return location == AppRoutes.cadastroEndereco
            ? null
            : AppRoutes.cadastroEndereco;
      }

      if (authState.autenticado) {
        const blocked = <String>{
          AppRoutes.splash,
          AppRoutes.entrada,
          AppRoutes.login,
          AppRoutes.cadastro,
          AppRoutes.cadastroEndereco,
          AppRoutes.visitante,
        };
        return blocked.contains(location) ? AppRoutes.home : null;
      }

      if (location == AppRoutes.splash) {
        return AppRoutes.entrada;
      }

      const protected = <String>{
        AppRoutes.home,
        AppRoutes.pedidos,
        AppRoutes.consumo,
        AppRoutes.menu,
        AppRoutes.perfil,
        AppRoutes.enderecos,
        AppRoutes.cartoes,
        AppRoutes.cadastroEndereco,
        AppRoutes.visitante,
      };
      return protected.contains(location) ? AppRoutes.entrada : null;
    },
  );
}

