import 'package:equatable/equatable.dart';
import '/../data/models/user.dart';

// State of User Cubit
abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

// State success login and get data
class UserSuccess extends UserState {
  final List<User> users;
  final int length;
  final bool hasReachedMax; // warning flag

  const UserSuccess({
    this.users = const [],
    this.length = 0,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [users, length, hasReachedMax];
}

// State loading user error
class UserError extends UserState {
  final String message;
  const UserError(this.message);

  @override
  List<Object> get props => [message];
}
