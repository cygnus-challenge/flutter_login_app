import 'package:flutter_bloc/flutter_bloc.dart';
import '/../data/models/user.dart';
import 'user_state.dart';

class UserController extends Cubit<UserState> {
  UserController() : super(UserSuccess());

  final List<User> _allFakeUsers = List.generate(
    48,
    (index) => User(
      id: '${index + 1}',
      username: 'User ${index + 1}',
      email: 'user${index + 1}@gmail.com',
      password: '',
    ),
  );

  final int _pageSize = 10;

  bool _isLoadingMore = false;

  final List<User> users = [];

  Future loadUsers() async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;

    if (state is! UserSuccess) return;

    await Future.delayed(const Duration(seconds: 1));
    final newUsers = _allFakeUsers.skip(users.length).take(_pageSize).toList();

    users.addAll(newUsers);
    emit(
      UserSuccess(
        users: users,
        length: users.length,
        hasReachedMax: newUsers.length < _pageSize,
      ),
    );

    _isLoadingMore = false;
  }
}
