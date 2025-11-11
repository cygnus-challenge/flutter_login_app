import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String password;
  // Email có thể là null, để làm form Register sau này
  final String? email;

  const User({required this.id, required this.username, required this.password, this.email});

  @override
  List<Object> get props => [id, username];
}