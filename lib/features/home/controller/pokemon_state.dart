import 'package:equatable/equatable.dart';

import '/../data/models/pokemon.dart';

// State of Pokemon Cubit
abstract class PokemonState extends Equatable {
  const PokemonState();
  @override
  List<Object> get props => [];
}

class PokemonInitial extends PokemonState {}

// State success login and get data from API
class PokemonLoaded extends PokemonState {
  final List<Pokemon> pokemons;
  final int length;
  final bool hasReachedMax; 

  const PokemonLoaded({
    this.pokemons = const [],
    this.length = 0,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [pokemons, length, hasReachedMax];
}

// State error when fetch data from API
class PokemonError extends PokemonState {
  final String message;

  const PokemonError(this.message);

  @override
  List<Object> get props => [message];
}