import '../entities/endereco.dart';

abstract class EnderecoRepository {
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
}
