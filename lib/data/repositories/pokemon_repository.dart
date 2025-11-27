import 'package:dio/dio.dart';
import '../models/pokemon.dart';
import '../models/pokemon_detail.dart';

class PokemonRepository {
  final Dio _dio;
  final String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  // Constructor with optional Dio parameter for easier testing
  PokemonRepository({Dio? dio}) : _dio = dio ?? Dio();

  // Get Pokemon list with pagination
  Future<List<Pokemon>> fetchPokemons({required int offset, required int limit}) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {'offset': offset, 'limit': limit},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'];    
        return data.map((json) => Pokemon.fromJon(json)).toList();
      } else {
        throw Exception('Failed to load Pokemons');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get Pokemon details by URL
  Future<PokemonDetails> getPokemonDetails(Pokemon pokemon) async {
    try {
      final response = await _dio.get(pokemon.url);
      if (response.statusCode == 200) {
        return PokemonDetails.fromJon(response.data);
      } else {
        throw Exception('Failed to load Pokemon details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}