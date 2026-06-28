import '../../../endereco/domain/entities/endereco.dart';
import '../repositories/cliente_repository.dart';

class SalvarMeuEnderecoUseCase {
  const SalvarMeuEnderecoUseCase(this.repository);

  final ClienteRepository repository;

  Future<Endereco> criar({
    required String cep,
    required String logradouro,
    required String numero,
    required String bairro,
    required String cidade,
    required String estado,
    String? complemento,
    String? referencia,
    String? label,
  }) {
    return repository.criarMeuEndereco(
      cep: cep,
      logradouro: logradouro,
      numero: numero,
      bairro: bairro,
      cidade: cidade,
      estado: estado,
      complemento: complemento,
      referencia: referencia,
      label: label,
    );
  }

  Future<Endereco> atualizar({
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
  }) {
    return repository.atualizarMeuEndereco(
      enderecoId: enderecoId,
      cep: cep,
      logradouro: logradouro,
      numero: numero,
      bairro: bairro,
      cidade: cidade,
      estado: estado,
      complemento: complemento,
      referencia: referencia,
      label: label,
    );
  }
}

