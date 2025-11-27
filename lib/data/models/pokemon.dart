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
    final uri = Uri.parse(url);
    return uri.pathSegments.lastWhere((element) => element.isNotEmpty);
  }

  String get nameCapitalized {
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  List<Object> get props => [name, url];
}

