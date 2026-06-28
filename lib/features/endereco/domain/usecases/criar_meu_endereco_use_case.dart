import '../entities/endereco.dart';
import '../repositories/endereco_repository.dart';

class CriarMeuEnderecoUseCase {
  const CriarMeuEnderecoUseCase(this.repository);

  final EnderecoRepository repository;

  Future<Endereco> call({
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
}

