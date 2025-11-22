import 'package:equatable/equatable.dart';

class Pokemon extends Equatable {
  final String name;
  final String url;

  const Pokemon({
    required this.name, 
    required this.url,
  });

  factory Pokemon.fromJon(Map<String,dynamic> json){
    return Pokemon(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }

  String get id {
    final parts = url.split('/');
    return parts[parts.length - 2];
  }

  String get imageUrl {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
  }

  @override
  List<Object> get props => [name, url];
}