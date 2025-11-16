import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/login_controller.dart';
import '../controller/login_state.dart';

import '../components/login_form.dart';
import '../components/loading_overlay.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginController(),
      child: Scaffold(
        body: BlocListener<LoginController, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              // Navigation to home page and send arguments
              Navigator.of(context).pushReplacementNamed('/home', arguments: state.user);
            } 
            else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              const LoginForm(),
              BlocBuilder<LoginController, LoginState>(
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return const LoadingOverlay();
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}