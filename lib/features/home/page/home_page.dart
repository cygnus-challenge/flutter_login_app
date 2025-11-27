import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import Controllerr, State and Widget
import '/../data/models/user.dart';
// import '../controller/user_controller.dart';
// import '../components/user_view.dart';
import '../controller/pokemon_controller.dart';
import '../components/pokemon_view.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.authenticatedUser});

  final User? authenticatedUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonController()
      ..fetchPokemons(),
      child: PokemonView(authenticatedUser: authenticatedUser), 
    );
  }
}