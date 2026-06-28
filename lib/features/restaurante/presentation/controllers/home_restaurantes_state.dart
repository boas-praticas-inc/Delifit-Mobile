import 'package:equatable/equatable.dart';

import '../../domain/entities/restaurante.dart';

class HomeRestaurantesState extends Equatable {
  const HomeRestaurantesState({
    this.carregando = false,
    this.restaurantes = const [],
    this.filtro = '',
    this.erro,
  });

  final bool carregando;
  final List<Restaurante> restaurantes;
  final String filtro;
  final String? erro;

  List<Restaurante> get filtrados {
    if (filtro.trim().isEmpty) {
      return restaurantes;
    }

    final query = filtro.toLowerCase();
    return restaurantes.where((restaurante) {
      return restaurante.nomeFantasia.toLowerCase().contains(query) ||
          (restaurante.descricao?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  HomeRestaurantesState copyWith({
    bool? carregando,
    List<Restaurante>? restaurantes,
    String? filtro,
    String? erro,
    bool limparErro = false,
  }) {
    return HomeRestaurantesState(
      carregando: carregando ?? this.carregando,
      restaurantes: restaurantes ?? this.restaurantes,
      filtro: filtro ?? this.filtro,
      erro: limparErro ? null : (erro ?? this.erro),
    );
  }

  @override
  List<Object?> get props => [carregando, restaurantes, filtro, erro];
}

