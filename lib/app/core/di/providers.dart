import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../../features/auth/domain/repositories/auth_repository.dart';
import '../../../features/auth/domain/usecases/entrar_com_telefone_use_case.dart';
import '../../../features/auth/domain/usecases/entrar_como_visitante_use_case.dart';
import '../../../features/auth/domain/usecases/obter_modo_visitante_use_case.dart';
import '../../../features/auth/domain/usecases/obter_sessao_atual_use_case.dart';
import '../../../features/auth/domain/usecases/registrar_cliente_use_case.dart';
import '../../../features/auth/domain/usecases/sair_use_case.dart';
import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../features/cliente/data/datasources/cliente_remote_data_source.dart';
import '../../../features/cliente/data/repositories/cliente_repository_impl.dart';
import '../../../features/cliente/domain/repositories/cliente_repository.dart';
import '../../../features/cliente/domain/usecases/atualizar_meu_perfil_use_case.dart';
import '../../../features/cliente/domain/usecases/buscar_meu_perfil_use_case.dart';
import '../../../features/cliente/domain/usecases/excluir_meu_cartao_use_case.dart';
import '../../../features/cliente/domain/usecases/excluir_meu_endereco_use_case.dart';
import '../../../features/cliente/domain/usecases/listar_meus_cartoes_use_case.dart';
import '../../../features/cliente/domain/usecases/listar_meus_enderecos_use_case.dart';
import '../../../features/cliente/domain/usecases/salvar_meu_cartao_use_case.dart';
import '../../../features/cliente/domain/usecases/salvar_meu_endereco_use_case.dart';
import '../../../features/cliente/presentation/controllers/cartoes_controller.dart';
import '../../../features/cliente/presentation/controllers/enderecos_controller.dart';
import '../../../features/cliente/presentation/controllers/perfil_cliente_controller.dart';
import '../../../features/endereco/data/datasources/endereco_remote_data_source.dart';
import '../../../features/endereco/data/repositories/endereco_repository_impl.dart';
import '../../../features/endereco/domain/repositories/endereco_repository.dart';
import '../../../features/endereco/domain/usecases/criar_meu_endereco_use_case.dart';
import '../../../features/endereco/presentation/controllers/cadastro_endereco_controller.dart';
import '../../../features/item_cardapio/data/datasources/item_cardapio_remote_data_source.dart';
import '../../../features/item_cardapio/data/repositories/item_cardapio_repository_impl.dart';
import '../../../features/item_cardapio/domain/repositories/item_cardapio_repository.dart';
import '../../../features/item_cardapio/domain/usecases/listar_itens_cardapio_use_case.dart';
import '../../../features/item_cardapio/presentation/controllers/home_itens_cardapio_controller.dart';
import '../../../features/restaurante/data/datasources/restaurante_remote_data_source.dart';
import '../../../features/restaurante/data/repositories/restaurante_repository_impl.dart';
import '../../../features/restaurante/domain/repositories/restaurante_repository.dart';
import '../../../features/restaurante/domain/usecases/listar_restaurantes_use_case.dart';
import '../../../features/restaurante/presentation/controllers/home_restaurantes_controller.dart';
import '../../routes/app_router.dart';
import '../network/api_client.dart';
import '../storage/secure_storage_service.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final secureStorageServiceProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService(),
);

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>(
  (ref) => AuthLocalDataSource(ref.watch(secureStorageServiceProvider)),
);

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(ref.watch(apiClientProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    localDataSource: ref.watch(authLocalDataSourceProvider),
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  ),
);

final authControllerProvider = ChangeNotifierProvider<AuthController>((ref) {
  final controller = AuthController(
    entrarComTelefoneUseCase:
        EntrarComTelefoneUseCase(ref.watch(authRepositoryProvider)),
    registrarClienteUseCase:
        RegistrarClienteUseCase(ref.watch(authRepositoryProvider)),
    obterSessaoAtualUseCase:
        ObterSessaoAtualUseCase(ref.watch(authRepositoryProvider)),
    entrarComoVisitanteUseCase:
        EntrarComoVisitanteUseCase(ref.watch(authRepositoryProvider)),
    obterModoVisitanteUseCase:
        ObterModoVisitanteUseCase(ref.watch(authRepositoryProvider)),
    sairUseCase: SairUseCase(ref.watch(authRepositoryProvider)),
  );
  Future.microtask(controller.inicializar);
  return controller;
});

final enderecoRemoteDataSourceProvider = Provider<EnderecoRemoteDataSource>(
  (ref) => EnderecoRemoteDataSource(ref.watch(apiClientProvider)),
);

final enderecoRepositoryProvider = Provider<EnderecoRepository>(
  (ref) => EnderecoRepositoryImpl(
    authLocalDataSource: ref.watch(authLocalDataSourceProvider),
    remoteDataSource: ref.watch(enderecoRemoteDataSourceProvider),
  ),
);

final cadastroEnderecoControllerProvider =
    ChangeNotifierProvider<CadastroEnderecoController>(
  (ref) => CadastroEnderecoController(
    criarMeuEnderecoUseCase:
        CriarMeuEnderecoUseCase(ref.watch(enderecoRepositoryProvider)),
  ),
);

final restauranteRemoteDataSourceProvider =
    Provider<RestauranteRemoteDataSource>(
  (ref) => RestauranteRemoteDataSource(ref.watch(apiClientProvider)),
);

final restauranteRepositoryProvider = Provider<RestauranteRepository>(
  (ref) => RestauranteRepositoryImpl(
    ref.watch(restauranteRemoteDataSourceProvider),
  ),
);

final homeRestaurantesControllerProvider =
    ChangeNotifierProvider<HomeRestaurantesController>(
  (ref) => HomeRestaurantesController(
    listarRestaurantesUseCase:
        ListarRestaurantesUseCase(ref.watch(restauranteRepositoryProvider)),
  ),
);

final itemCardapioRemoteDataSourceProvider =
    Provider<ItemCardapioRemoteDataSource>(
  (ref) => ItemCardapioRemoteDataSource(ref.watch(apiClientProvider)),
);

final itemCardapioRepositoryProvider = Provider<ItemCardapioRepository>(
  (ref) => ItemCardapioRepositoryImpl(
    ref.watch(itemCardapioRemoteDataSourceProvider),
  ),
);

final homeItensCardapioControllerProvider =
    ChangeNotifierProvider<HomeItensCardapioController>(
  (ref) => HomeItensCardapioController(
    listarItensCardapioUseCase:
        ListarItensCardapioUseCase(ref.watch(itemCardapioRepositoryProvider)),
  ),
);

final clienteRemoteDataSourceProvider = Provider<ClienteRemoteDataSource>(
  (ref) => ClienteRemoteDataSource(ref.watch(apiClientProvider)),
);

final clienteRepositoryProvider = Provider<ClienteRepository>(
  (ref) => ClienteRepositoryImpl(
    authLocalDataSource: ref.watch(authLocalDataSourceProvider),
    remoteDataSource: ref.watch(clienteRemoteDataSourceProvider),
  ),
);

final perfilClienteControllerProvider =
    ChangeNotifierProvider<PerfilClienteController>(
  (ref) => PerfilClienteController(
    buscarMeuPerfilUseCase:
        BuscarMeuPerfilUseCase(ref.watch(clienteRepositoryProvider)),
    atualizarMeuPerfilUseCase:
        AtualizarMeuPerfilUseCase(ref.watch(clienteRepositoryProvider)),
  ),
);

final enderecosControllerProvider =
    ChangeNotifierProvider<EnderecosController>(
  (ref) => EnderecosController(
    listarMeusEnderecosUseCase:
        ListarMeusEnderecosUseCase(ref.watch(clienteRepositoryProvider)),
    salvarMeuEnderecoUseCase:
        SalvarMeuEnderecoUseCase(ref.watch(clienteRepositoryProvider)),
    excluirMeuEnderecoUseCase:
        ExcluirMeuEnderecoUseCase(ref.watch(clienteRepositoryProvider)),
  ),
);

final cartoesControllerProvider = ChangeNotifierProvider<CartoesController>(
  (ref) => CartoesController(
    listarMeusCartoesUseCase:
        ListarMeusCartoesUseCase(ref.watch(clienteRepositoryProvider)),
    salvarMeuCartaoUseCase:
        SalvarMeuCartaoUseCase(ref.watch(clienteRepositoryProvider)),
    excluirMeuCartaoUseCase:
        ExcluirMeuCartaoUseCase(ref.watch(clienteRepositoryProvider)),
  ),
);

final appRouterProvider = Provider((ref) {
  final authController = ref.watch(authControllerProvider);
  return buildRouter(authController);
});
