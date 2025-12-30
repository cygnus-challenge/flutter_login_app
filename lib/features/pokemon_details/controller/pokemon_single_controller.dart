import 'package:auth_app/core/result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/pokemon.dart';
import '../../../data/repositories/pokemon_repository.dart';
import 'pokemon_single_state.dart';

class PokemonSingleController extends Cubit<PokemonSingleState> {
  PokemonSingleController({
    required PokemonRepository repository,
    required Pokemon initialPokemon,
  }) : _repository = repository,
      super(PokemonSingleState(pokemon: initialPokemon));

  final PokemonRepository _repository;

  // Function to load detail and merge it into the current Pokémon
  Future<void> loadPokemonDetail() async {

    // 1. Check if details already exist
    if (state.pokemon.details != null) return;

    // 2. Emit loading -> show Spinner
    emit(state.copyWith(isLoading: true, error: null));

    // 3. Call Repository
    final result = await _repository.getPokemonDetail(state.pokemon.id);

    // 4. Handle the result using a switch case
    switch (result) {
      // SUCCESS
      case Success(data: final details):
        final updatedPokemon = state.pokemon.copyWith(details: details);
        emit(state.copyWith(
          isLoading: false,
          pokemon: updatedPokemon,
        ));
        break;

      // FAILURE
      case Failure(message :final msg):
        emit(state.copyWith(
          isLoading: false,
          error: msg.toString(),
        ));
        break;
    }
  }
}