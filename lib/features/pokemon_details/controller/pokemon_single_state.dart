import 'package:equatable/equatable.dart';
import '../../../data/models/pokemon.dart';

// State of Pokemon Cubit
class PokemonSingleState extends Equatable {
  const PokemonSingleState({
    required this.pokemon,
    this.isLoading = false,
    this.error,
  });

  final Pokemon pokemon;
  final bool isLoading;
  final String? error;
  
  PokemonSingleState copyWith({
    Pokemon? pokemon,
    bool? isLoading,
    String? error,
  }) {
    return PokemonSingleState (
      pokemon: pokemon ?? this.pokemon,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
  
  @override
  List<Object?> get props => [pokemon, isLoading, error];
}