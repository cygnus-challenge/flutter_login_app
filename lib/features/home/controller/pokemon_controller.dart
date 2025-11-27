import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/pokemon.dart';
import '../../../data/repositories/pokemon_repository.dart';
import 'pokemon_state.dart';

class PokemonController extends Cubit<PokemonState> {
  PokemonController() :  super(PokemonLoaded());

  // Inject repository and Controller
  final _repository = PokemonRepository();
  // Pokemon screen limit
  static const int _limit = 10;
  bool _isLoadingMore = false;
  final List<Pokemon> _pokemons = [];

  Future<void> fetchPokemons() async {

    if (_isLoadingMore) return;
    _isLoadingMore = true;
    if (state is! PokemonLoaded) return;

    final newPokemons = await _repository.fetchPokemons(
        offset: _pokemons.length,
        limit: _limit,
      );

    _pokemons.addAll(newPokemons);

    emit(PokemonLoaded(
      pokemons: List.of(_pokemons),
      length: _pokemons.length,
      hasReachedMax: newPokemons.length < _limit,
    ));

    _isLoadingMore = false;
  }

  Future<void> refreshPokemons() async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;
    _pokemons.clear();

    final newPokemons = await _repository.fetchPokemons(
        offset: 0,
        limit: 20,
      );

    _pokemons.addAll(newPokemons);

    emit(PokemonLoaded(
      pokemons: List.of(_pokemons),
      length: _pokemons.length,
      hasReachedMax: newPokemons.length < _limit,
    ));

    _isLoadingMore = false;
    
  }
}