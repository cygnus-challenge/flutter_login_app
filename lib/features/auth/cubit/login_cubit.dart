import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';
import '/../data/models/user.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login(String username, String password) async {
    emit(LoginLoading());

    await Future.delayed(const Duration(seconds: 2));

    if (username.toLowerCase() == 'admin' && password == '123') {
      const User loggedInUser = User(
        id: '0',
        username: 'admin',
        password: '123',
        email: 'admin@gmail.com',
      );
      emit(LoginSuccess(loggedInUser));
    } else {
      emit(const LoginFailure('Tên đăng nhập hoặc mật khẩu không đúng!'));
    }
  }
}