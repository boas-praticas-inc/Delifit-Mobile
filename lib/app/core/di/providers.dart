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
import '../../../features/endereco/data/datasources/endereco_remote_data_source.dart';
import '../../../features/endereco/data/repositories/endereco_repository_impl.dart';
import '../../../features/endereco/domain/repositories/endereco_repository.dart';
import '../../../features/endereco/domain/usecases/criar_meu_endereco_use_case.dart';
import '../../../features/endereco/presentation/controllers/cadastro_endereco_controller.dart';
import '../network/api_client.dart';
import '../storage/secure_storage_service.dart';
import '../../routes/app_router.dart';

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

final appRouterProvider = Provider((ref) {
  final authController = ref.watch(authControllerProvider);
  return buildRouter(authController);
});
