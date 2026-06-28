import '../../domain/entities/cartao_cliente.dart';

class CartaoClienteModel extends CartaoCliente {
  const CartaoClienteModel({
    required super.id,
    required super.clienteId,
    required super.nomeTitular,
    required super.ultimosQuatroDigitos,
    required super.bandeira,
    required super.padrao,
    super.tokenGateway,
    super.criadoEm,
  });

  factory CartaoClienteModel.fromJson(Map<String, dynamic> json) {
    return CartaoClienteModel(
      id: json['id'] as int,
      clienteId: json['cliente_id'] as int,
      nomeTitular: json['nome_titular'] as String,
      ultimosQuatroDigitos: json['ultimos_quatro_digitos'] as String,
      bandeira: json['bandeira'] as String,
      padrao: json['padrao'] as bool,
      tokenGateway: json['token_gateway'] as String?,
      criadoEm: json['criado_em'] as String?,
    );
  }
}

