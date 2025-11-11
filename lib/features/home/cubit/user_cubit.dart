import 'package:auth_app/data/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  final List<User> _fakeUsers = [
    const User(id: '1', username: 'Nghi', password: '123', email: 'nghi@example.com'),
    const User(id: '2', username: 'An', password: '123', email: 'an@example.com'),
    const User(id: '3', username: 'Khang', password: '123', email: 'khang@example.com'),
    const User(id: '4', username: 'My', password: '123', email: 'my@example.com'),
    const User(id: '5', username: 'Chi', password: '123', email: 'chi@example.com'),
  ];

  Future<void> loadUsers() async {
    emit(UserLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(UserSuccess(_fakeUsers));
  }
}