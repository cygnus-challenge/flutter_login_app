import 'package:shared_preferences/shared_preferences.dart';
import 'data/data_sources/local_storage.dart';
import 'data/repositories/pokemon_repository.dart';
import 'core/network/dio_client.dart';

// Class container includes dependencies
class AppDependencies {
  AppDependencies({required this.pokemonRepository});

  final PokemonRepository pokemonRepository;

  static Future<AppDependencies> init() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final localStorage = LocalStorage(sharedPrefs);
    
    final dio = DioClient().dio; 

    final repository = PokemonRepository(
      localStorage: localStorage,
      dio: dio,
    );

    return AppDependencies(pokemonRepository: repository);
  }
}