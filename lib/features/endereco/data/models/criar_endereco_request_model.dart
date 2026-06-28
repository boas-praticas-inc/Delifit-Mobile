class CriarEnderecoRequestModel {
  const CriarEnderecoRequestModel({
    required this.cep,
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
    this.complemento,
    this.referencia,
    this.label,
  });

  final String cep;
  final String logradouro;
  final String numero;
  final String bairro;
  final String cidade;
  final String estado;
  final String? complemento;
  final String? referencia;
  final String? label;

  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'logradouro': logradouro,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'complemento': complemento,
      'referencia': referencia,
      'label': label,
    };
  }
}

