import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/result.dart';
import '../../../data/repositories/pokemon_repository.dart';
import 'pokemon_list_state.dart';

class PokemonListController extends Cubit<PokemonListState> {
  PokemonListController({required PokemonRepository repository}) 
  : _repository = repository,  
  super(PokemonListInitial());

  // Dependency Injection: Repository is injected from the outside
  final PokemonRepository _repository;

  // Config Pagination
  static const int _limit = 20;
  int _offset = 0;

  // 1. Refresh Data
  Future<void> refreshPokemonList() async {
    _offset = 0;
    emit(PokemonListLoading());
    await loadPokemonList();
  }

  // 2. Load Data (First Time or Load More)
  Future<void> loadPokemonList() async {

    // A. GUARD CLAUSE: Check conditions to prevent unnecessary API calls.
    if (state is PokemonListLoaded) {
      final loadedState = state as PokemonListLoaded;
      if (loadedState.hasReachedMax || loadedState.isLoadingMore) return;
    }

    // B. UPDATE STATE: Update state before calling the API
    if (state is PokemonListLoaded) {
      emit((state as PokemonListLoaded).copyWith(isLoadingMore: true));
    } else {
      emit(PokemonListLoading());
    }

    // C. CALL REPOSITORY
    final result = await _repository.getPokemonList(
      offset: _offset,
      limit: _limit,
    );

    // 4. HANDLE RESULT
    switch (result) {
      case Success(data: final newPokemons):
        final isMax = newPokemons.length < _limit;
        _offset += newPokemons.length;

        if (state is PokemonListLoaded) {
          final currentList = (state as PokemonListLoaded).pokemons;
          emit(PokemonListLoaded(
            pokemons: [...currentList, ...newPokemons],
            hasReachedMax: isMax,
            isLoadingMore: false,
          ));
        } else {
          emit(PokemonListLoaded(
            pokemons: newPokemons,
            hasReachedMax: isMax,
            isLoadingMore: false,
          ));
        }
        break;
      
      case Failure(message: final msg):
        if (state is PokemonListLoaded) {
          emit((state as PokemonListLoaded).copyWith(isLoadingMore: false));
        } else {
          emit(PokemonListError(msg));
        }
        break;
    }
  }

}