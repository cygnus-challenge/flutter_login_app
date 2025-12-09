import 'dart:convert';
import 'package:equatable/equatable.dart';

import 'pokemon_detail.dart';

class Pokemon extends Equatable {
  const Pokemon({
    required this.id,
    required this.name, 
    required this.url,
    this.details,
  });
  
  final int id;
  final String name;
  final String url;
  final PokemonDetails? details;

  // 1. Convert from JSON Map to Object - used to read data from API/Cache
  factory Pokemon.fromJson(Map<String,dynamic> json){
    int id;
    if (json['id'] != null) {
      id = json['id'] as int;
    } else {
      final url = json['url'] as String;
      final idString = url.split('/').where((e) => e.isNotEmpty).last;
      id = int.parse(idString);
    }

    return Pokemon(
      id: id,
      name: json['name'] as String,
      url: json['url'] as String,
      details: json['details'] != null 
      ? PokemonDetails.fromJson(json['details'])
      : null,
    );
  }

  Pokemon copyWith({
    int? id,
    String? name,
    String? url,
    PokemonDetails? details,
  }) {
    return Pokemon(
      id: id ?? this.id,
      name: name ?? this.name, 
      url: url ?? this.url,
      details: details ?? this.details,
    );
  }

  // 2. Convert from Object to JSON Map - prepares data for download
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'details': details?.toJson(),
    };
  }

  String toRawJson() => json.encode(toJson());

  factory Pokemon.fromRawJson(String str) => Pokemon.fromJson(json.decode(str));

  String get nameCapitalized {
    return name[0].toUpperCase() + name.substring(1);
  }

  // Getter for imageUrl when detail has not been loaded
  String get imageUrl {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }

  // Getter with priority: detail image → default image
  String get displayImage => details?.imageUrl ?? imageUrl;

  @override
  List<Object?> get props => [id, name, url, details];
}

