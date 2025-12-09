import 'package:equatable/equatable.dart';

import '/../data/models/pokemon.dart';

// State of Pokemon Cubit
class PokemonListState extends Equatable {
  const PokemonListState();
  @override
  List<Object> get props => [];
}

class PokemonListInitial extends PokemonListState {}

class PokemonListLoading extends PokemonListState {}

// State success login and get data from API
class PokemonListLoaded extends PokemonListState {
  final List<Pokemon> pokemons;
  final int length;
  final bool hasReachedMax; 
  final bool isLoadingMore;

  const PokemonListLoaded({
    this.pokemons = const <Pokemon>[],
    this.length = 0,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  // Helper function (keep UI smooth)
  PokemonListLoaded copyWith({
    List<Pokemon>? pokemons,
    int? lenght,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return PokemonListLoaded(
      pokemons: pokemons ?? this.pokemons,
      length: lenght ?? length,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [pokemons, length, hasReachedMax, isLoadingMore];
}

// State error when fetch data from API
class PokemonListError extends PokemonListState {
  const PokemonListError(this.errorMsg);
  final String errorMsg;

  @override
  List<Object> get props => [errorMsg];
}