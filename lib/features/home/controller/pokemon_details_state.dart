import 'package:equatable/equatable.dart';

import '/../data/models/pokemon_detail.dart';

// State of Pokemon Cubit
abstract class PokemonDetailsState extends Equatable {
  const PokemonDetailsState();
  @override
  List<Object> get props => [];
}

class PokemonDetailsInitial extends PokemonDetailsState {}

// State success login and get data from API
class PokemonDetailsLoaded extends PokemonDetailsState {
  final PokemonDetails pokemonDetails;
  final String name;

  const PokemonDetailsLoaded({
    this.pokemonDetails = const PokemonDetails(
      imageUrl: '',
      height: '',
      weight: '',
      abilities: [],
    ),
    this.name = '',
  });

  @override
  List<Object> get props => [pokemonDetails, name];
}

// State error when fetch data from API
class PokemonDetaislError extends PokemonDetailsState {
  final String message;

  const PokemonDetaislError(this.message);

  @override
  List<Object> get props => [message];
}