import 'package:auth_app/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import Controllerr, State and Widget
import '../controller/user_controller.dart';
import 'package:auth_app/features/home/components/home_view.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.authenticatedUser});

  final User authenticatedUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserController()..loadUsers(),
      child: HomeView(authenticatedUser: authenticatedUser),     
    );
  }
}