import '../../../endereco/domain/entities/endereco.dart';
import '../entities/cartao_cliente.dart';
import '../entities/cliente_perfil.dart';

abstract class ClienteRepository {
  Future<ClientePerfil> buscarMeuPerfil();

  Future<ClientePerfil> atualizarMeuPerfil({
    required String nomeCompleto,
    required String cpf,
    required String telefone,
    required DateTime? dataNascimento,
  });

  Future<List<Endereco>> listarMeusEnderecos();

  Future<Endereco> criarMeuEndereco({
    required String cep,
    required String logradouro,
    required String numero,
    required String bairro,
    required String cidade,
    required String estado,
    String? complemento,
    String? referencia,
    String? label,
  });

  Future<Endereco> atualizarMeuEndereco({
    required int enderecoId,
    required String cep,
    required String logradouro,
    required String numero,
    required String bairro,
    required String cidade,
    required String estado,
    String? complemento,
    String? referencia,
    String? label,
  });

  Future<void> excluirMeuEndereco(int enderecoId);

  Future<List<CartaoCliente>> listarMeusCartoes();

  Future<CartaoCliente> criarMeuCartao({
    required String nomeTitular,
    required String ultimosQuatroDigitos,
    required String bandeira,
    required bool padrao,
    String? tokenGateway,
  });

  Future<CartaoCliente> atualizarMeuCartao({
    required int cartaoId,
    required String nomeTitular,
    required String ultimosQuatroDigitos,
    required String bandeira,
    required bool padrao,
    String? tokenGateway,
  });

  Future<void> excluirMeuCartao(int cartaoId);
}

