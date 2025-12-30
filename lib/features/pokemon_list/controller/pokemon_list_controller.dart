import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/result.dart';
import '../../../data/repositories/pokemon_repository.dart';
import '../../../data/models/pokemon.dart';
import 'pokemon_list_state.dart';

class PokemonListController extends Cubit<PokemonListState> {
  PokemonListController({required PokemonRepository repository}) 
  : _repository = repository,  
  super(PokemonListInitial());

  // Dependency Injection: Repository is injected from the outside
  final PokemonRepository _repository;

  // Config Pagination
  static const int _limit = 20;
  int _nextOffset = 0;
  int _currentPage = 1;
  final List<Pokemon> _allPokemons = [];
  bool _isLoading = false;

  // 1. Refresh Data
  // Refresh = Go to Page 1
  Future<void> refreshPokemonList() async {
    await goToPage(1);
  }

  // 2. Load Data (First Time or Load More)
  // CASE: SCROLL (Load More)
  Future<void> loadPokemonList() async {

    if (_isLoading) return;
    _isLoading = true;

    if (_allPokemons.isEmpty) {
      emit(PokemonListLoading());
    } else {
      emit(PokemonListLoaded(
        pokemons: List.from(_allPokemons), 
        isLoadingMore: true,
        hasReachedMax: false,
      ));
    }

    final result = await _repository.getPokemonList(
      offset: _nextOffset,
      limit: _limit,
    );

    _handleResult(result, isReplacement: true);
  }
  // CASE 2: GO TO PAGE (Jump to specific page)
  Future<void> goToPage(int page) async {
    if (_isLoading) return;
    _isLoading = true;

    _nextOffset = (page - 1) * _limit;
    _currentPage = page;
    _allPokemons.clear();
    emit(PokemonListLoading());

    final result = await _repository.getPokemonList(
      offset: _nextOffset,
      limit: _limit,
    );

    _handleResult(result, isReplacement: true);
  }

  // Handle Result from Repository
  void _handleResult(Result<dynamic> result, {required bool isReplacement}) {
    switch (result) {
      case Success(data: final response):
        final newPokemons = response.pokemons;
        final totalCount = response.totalCount;
        _allPokemons.addAll(newPokemons);    
        _nextOffset += newPokemons.length as int;    
        final isMax = _nextOffset >= totalCount; 

        emit(PokemonListLoaded(
          pokemons: List.from(_allPokemons),
          totalCount: totalCount,
          currentPage: _currentPage,
          hasReachedMax: isMax,
          isLoadingMore: false,
        ));
        break;

      case Failure(message: final msg):
        if (_allPokemons.isNotEmpty) {
           emit((state as PokemonListLoaded).copyWith(isLoadingMore: false));
        } else {
          emit(PokemonListError(msg));
        }
        break;
    }
    _isLoading = false;
  }
}