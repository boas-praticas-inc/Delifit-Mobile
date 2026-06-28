import 'package:equatable/equatable.dart';

class CartaoCliente extends Equatable {
  const CartaoCliente({
    required this.id,
    required this.clienteId,
    required this.nomeTitular,
    required this.ultimosQuatroDigitos,
    required this.bandeira,
    required this.padrao,
    this.tokenGateway,
    this.criadoEm,
  });

  final int id;
  final int clienteId;
  final String nomeTitular;
  final String ultimosQuatroDigitos;
  final String bandeira;
  final bool padrao;
  final String? tokenGateway;
  final String? criadoEm;

  @override
  List<Object?> get props => [
        id,
        clienteId,
        nomeTitular,
        ultimosQuatroDigitos,
        bandeira,
        padrao,
        tokenGateway,
        criadoEm,
      ];
}

