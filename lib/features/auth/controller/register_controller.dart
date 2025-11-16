import 'package:auth_app/features/auth/controller/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterController extends Cubit<RegisterState> {
  RegisterController() : super(RegisterInitial());

  Future<void> register(String username,String email, String password) async {
    emit(RegisterLoading());

    await Future.delayed(const Duration(seconds: 1));

  }
}