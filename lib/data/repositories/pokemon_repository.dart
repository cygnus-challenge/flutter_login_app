import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../core/result.dart';
import '../models/pokemon.dart';
import '../data_sources/local_storage.dart';
import '../models/pokemon_detail.dart';

class PokemonRepository {
  PokemonRepository({
    required LocalStorage localStorage, 
    required Dio dio
  }) : _localStorage = localStorage,
      _dio = dio;

  final LocalStorage _localStorage;
  final Dio _dio;

  static const _kListKey = 'pokemon_list_cache';
  String _detailKey(int id) => 'detail_$id';

  // --- GET LIST (Logic: Smart Cache & Fallback)---
  Future<Result<PokemonResponse>> getPokemonList({
    required int offset, 
    required int limit
    }) async {

      // 1. Check Cache: 
      final cachedData = _getCachedList();
      if (cachedData != null && cachedData.isNotEmpty) {
        return Success(PokemonResponse(pokemons: cachedData, totalCount: cachedData.length));
      }

      // 2. Call API
      try {
        final response = await _dio.get(
          'pokemon',
          queryParameters: {'offset': offset, 'limit': limit},
        );

        final int totalCount = response.data['count'] as int;

        final List results = response.data['results'] as List;
        final remoteData = results.map((e) => Pokemon.fromJson(e)).toList();

        // 3. Save Cache 
        await _localStorage.saveObjecList(_kListKey, remoteData, (e) => e.toJson());

        return Success(PokemonResponse(pokemons: remoteData, totalCount: totalCount));

      } catch (e) {
        return Failure('Unknown error: $e');
      }
  }

  // --- GET DETAIL (Logic: Stale-While-Revalidate OR Cache Priority) ---
  Future<Result<PokemonDetails>> getPokemonDetail(int id) async{
    final key = _detailKey(id);

    // 1. Get Cache
    final cachedDetail = _localStorage.getObj(key, (json) => PokemonDetails.fromJson(json));
    
    if (cachedDetail != null) {
      return Success(cachedDetail);
    }

    try {

      // 2. Call API
      final response = await _dio.get('pokemon/$id');
      final pokemonDetail = PokemonDetails.fromJson(response.data);

      // 3. Save Cache
      await _localStorage.saveObj(key, pokemonDetail, (e) => e.toJson());
      await _updateListCacheWithDetail(id, pokemonDetail);

      return Success(pokemonDetail);  
    } catch (e) {
      return Failure('Load detail FAILED: $e');
    }
  }

  // --- HELPER: Sync detail data into the list  ---
  Future<void> _updateListCacheWithDetail(int id, PokemonDetails detail) async {
    try {

      // 1. Get cached list
      final currentList = _getCachedList();
      if (currentList == null || currentList.isEmpty) return;

      // 2. Find Pokemon index need to update
      final index = currentList.indexWhere((p) => p.id == id);

      // If not found → skipip
      if (index == -1) return;

      // 3. Update Pokemon with new detail
      final updatedPokemon = currentList[index].copyWith(details: detail);
      currentList[index] = updatedPokemon;

      // 4. Overwrite the new list in LocalStorage
      await _localStorage.saveObjecList(_kListKey, currentList, (e) => e.toJson());
      
    } catch (e) {
      debugPrint('Cache enrichment failed: $e');
    }
  }

  // Helper: Get Cache List to reuse code
  List<Pokemon>? _getCachedList() {
    return _localStorage.getObjList(_kListKey, (json) => Pokemon.fromJson(json));
  }

}

class PokemonResponse {
  final List<Pokemon> pokemons;
  final int totalCount;
  PokemonResponse({required this.pokemons, required this.totalCount});
}