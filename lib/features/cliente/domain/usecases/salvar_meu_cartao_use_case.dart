import '../entities/cartao_cliente.dart';
import '../repositories/cliente_repository.dart';

class SalvarMeuCartaoUseCase {
  const SalvarMeuCartaoUseCase(this.repository);

  final ClienteRepository repository;

  Future<CartaoCliente> criar({
    required String nomeTitular,
    required String ultimosQuatroDigitos,
    required String bandeira,
    required bool padrao,
    String? tokenGateway,
  }) {
    return repository.criarMeuCartao(
      nomeTitular: nomeTitular,
      ultimosQuatroDigitos: ultimosQuatroDigitos,
      bandeira: bandeira,
      padrao: padrao,
      tokenGateway: tokenGateway,
    );
  }

  Future<CartaoCliente> atualizar({
    required int cartaoId,
    required String nomeTitular,
    required String ultimosQuatroDigitos,
    required String bandeira,
    required bool padrao,
    String? tokenGateway,
  }) {
    return repository.atualizarMeuCartao(
      cartaoId: cartaoId,
      nomeTitular: nomeTitular,
      ultimosQuatroDigitos: ultimosQuatroDigitos,
      bandeira: bandeira,
      padrao: padrao,
      tokenGateway: tokenGateway,
    );
  }
}

