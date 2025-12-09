import 'dart:convert';

import 'package:equatable/equatable.dart';

class PokemonDetails extends Equatable {
  const PokemonDetails({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.abilities,
  });

  final int id;
  final String name;
  final String imageUrl;
  final String height;
  final String weight;
  final List <String> abilities;

  // 1. Convert from JSON Map to Object - used to read data from API/Cache
  factory PokemonDetails.fromJson(Map<String,dynamic> json){
    final sprites = json['sprites'];
    String imageUrl = '';

    if (json['imageUrl'] != null) {
      imageUrl = json['imageUrl'];
    } else if (sprites != null){
      imageUrl = sprites['other']?['official-artwork']?['front_default'] ?? '';
    }

    return PokemonDetails(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: imageUrl,
      height: json['height'].toString(), // Placeholder for description
      weight: json['weight'].toString(),
      abilities: (json['abilities'] as List)
          .map((e) {
            if (e is String) return e;
            return e['ability']['name'] as String;
          }).toList(),
    );
  }

  // 2. Convert from Object to JSON Map - prepares data for download
  Map<String, dynamic> toJson() {
    return {
      'sprites': {
        'other': {
          'official-artwork': {
            'front_default': imageUrl
          }
        }
      },
      'height': height,
      'weight': weight,
      'abilities': abilities,
    };
  }

  // Helper: Convert an Object to a String to save to SharedPreferences
  String toRawJson() => json.encode(toJson());

  // Helper: Convert a String in SharePreferences to an Object
  factory PokemonDetails.fromRawJson(String str) => PokemonDetails.fromJson(json.decode(str));

  @override
  List<Object> get props => [id, name, imageUrl, height, weight, abilities];
}

