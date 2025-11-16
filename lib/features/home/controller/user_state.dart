import 'package:equatable/equatable.dart';
import 'package:auth_app/data/models/user.dart';

// State of User Cubit
abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

// State success login and get data login
class UserSuccess extends UserState {
  final List<User> users;
  final bool hasReachedMax; // warning flag

  const UserSuccess({
    this.users = const [],
    this.hasReachedMax = false,
  });

  UserSuccess copyWith({
    List<User>? users,
    bool? hasReachedMax,
  }) {
    return UserSuccess(
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [users];
}


class UserError extends UserState {
  final String message;
  const UserError(this.message);
  
  @override
  List<Object> get props => [message];
}