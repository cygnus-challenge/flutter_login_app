import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/pokemon.dart';
import '../../../data/repositories/pokemon_repository.dart';
import 'pokemon_details_state.dart';

class PokemonDetailsController extends Cubit<PokemonDetailsState> {
  PokemonDetailsController() :  super(PokemonDetailsLoaded());

  // Inject repository and Controller
  final _repository = PokemonRepository();

  Future<void> getPokemonDetails(Pokemon pokemon) async {
    if (state is! PokemonDetailsLoaded) return;

    final details = await _repository.getPokemonDetails(pokemon);

    emit(PokemonDetailsLoaded(
      pokemonDetails: details,
      name: pokemon.name,
    ));
  }
}