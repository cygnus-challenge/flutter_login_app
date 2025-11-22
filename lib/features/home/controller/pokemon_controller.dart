import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../data/models/pokemon.dart';
import 'pokemon_state.dart';

class PokemonController extends Cubit<PokemonState> {
  PokemonController() : super(PokemonLoaded());

  final Dio _dio = Dio();
  // Pokemon screen limit
  static const int _limit = 10;
  bool _isLoadingMore = false;
  final List<Pokemon> pokemons = [];

  Future fetchPokemons() async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;
    if (state is! PokemonLoaded) return;
      
    await Future.delayed(const Duration(seconds: 1));
    final response = await _dio.get(
      'https://pokeapi.co/api/v2/pokemon',
      queryParameters: {
        'offset': pokemons.length,
        'limit': _limit,
      }
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['results'];
      final newPokemons = data.map((json) => Pokemon.fromJon(json)).toList();
      pokemons.addAll(newPokemons);

      emit(
        PokemonLoaded(
          pokemons: pokemons,
          length: pokemons.length,
          hasReachedMax: newPokemons.length < _limit,
        )
      );

      _isLoadingMore = false;
    } else {
        emit(PokemonError('Failed to load pokemon: ${response.statusCode}'));
    }
  }
}