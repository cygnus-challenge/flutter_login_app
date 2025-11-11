import 'package:equatable/equatable.dart';
import 'package:auth_app/data/models/user.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
}

/// Trạng thái ban đầu
class UserInitial extends UserState {}

/// Trạng thái đang tải danh sách người dùng
class UserLoading extends UserState {}

/// Trạng thái tải danh sách người dùng thành công, lấy thông tin vừa đăng nhập
class UserSuccess extends UserState {
  final List<User> users;
  const UserSuccess(this.users);
  @override
  List<Object> get props => [users];
}


class UserError extends UserState {
  final String message;
  const UserError(this.message);
  @override
  List<Object> get props => [message];
}