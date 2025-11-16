import '/../data/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_state.dart';

class UserController extends Cubit<UserState> {
  UserController() : super(UserInitial());

  final List<User> _allFakeUsers = List.generate(
    48,
    (index) => User(
      id: '${index + 1}',
      username: 'User ${index + 1}',
      email: 'user${index + 1}@gmail.com', password: '',
    ),
  );

  final int _pageSize = 10;

  bool _isLoadingMore = false;

  int get totalUsersCount => _allFakeUsers.length;

  // Call API
  Future<void> loadUsers() async {
    if (state is UserLoading) return;

    emit(UserLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));

      final users = _allFakeUsers.take(_pageSize).toList();

      emit(UserSuccess(
        users: users,
        hasReachedMax: users.length == _allFakeUsers.length,
      ));
    } catch (e) {
      emit(UserError('Don\'t download user list: ${e.toString()}'));
    } 
  }

  Future<void> loadMoreUsers() async {
    if (_isLoadingMore || state is! UserSuccess) return;

    final currentState = state as UserSuccess;

    if (currentState.hasReachedMax) return;

    _isLoadingMore = true;

    try {
      await Future.delayed(const Duration(seconds: 1));

      final currentCount = currentState.users.length;

      final newUsers = _allFakeUsers
          .skip(currentCount)
          .take(_pageSize)
          .toList();

      emit(currentState.copyWith(
        users: List.of(currentState.users)..addAll(newUsers),
        hasReachedMax: newUsers.isEmpty ||
        (currentCount + newUsers.length) ==
        _allFakeUsers.length,
      ));
    } catch (e) {
      print('Lỗi khi tải thêm: ${e.toString()}');
    } finally {
      _isLoadingMore = false;
    }
  }
}