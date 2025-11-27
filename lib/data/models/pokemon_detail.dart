import 'package:equatable/equatable.dart';

class PokemonDetails extends Equatable {
  final String imageUrl;
  final String height;
  final String weight;
  final List <String> abilities;

  const PokemonDetails({
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.abilities,
  });

  factory PokemonDetails.fromJon(Map<String,dynamic> json){
    final sprites = json['sprites'];
    String imageUrl = '';

    if (sprites != null) {
      imageUrl = sprites['other']?['official-artwork']?['front_default'] ?? '';
    }

    return PokemonDetails(
      imageUrl: imageUrl,
      height: json['height'].toString(), // Placeholder for description
      weight: json['weight'].toString(),
      abilities: (json['abilities'] as List)
          .map((e) => e['ability']['name'] as String)
          .toList(),
    );
  }

  @override
  List<Object> get props => [imageUrl, height, weight, abilities];
}

