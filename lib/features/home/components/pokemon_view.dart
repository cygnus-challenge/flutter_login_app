import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import Controllerr, State and Widget
import '/../core/theme/app_pallet.dart';
import '/../data/models/user.dart';
import '../controller/pokemon_controller.dart';
import '../controller/pokemon_state.dart';
import 'pokemon_list_item.dart';

class PokemonView extends StatefulWidget {
  const PokemonView({super.key, required this.authenticatedUser});

  final User? authenticatedUser;

  @override
  State<PokemonView> createState() => _PokemonViewState();
}

class _PokemonViewState extends State<PokemonView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Call controller to load more
      context.read<PokemonController>().fetchPokemons();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.authenticatedUser != null
            ? 'Welcome ${widget.authenticatedUser?.username ?? ''}'
            : 'Home',
          style: TextStyle(
            color: AppPallet.gradient1,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: AppPallet.gradient1,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: BlocBuilder<PokemonController, PokemonState>(
        builder: (context, state) {
          if (state is PokemonInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // Load Success
          if (state is PokemonLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, 
                          vertical: 12.0,
                  ),
                  child: Text(
                    'List of Pokemon',
                    style: TextStyle(
                      color: AppPallet.greyColor,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          
                // Card List
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: state.hasReachedMax 
                      ? state.pokemons.length
                      : state.pokemons.length + 1,
        
                    itemBuilder: (context, index) {
                      if (index == state.length &&
                        !state.hasReachedMax) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      
                      final pokemon = state.pokemons[index];
                      return PokemonListItem(pokemon: pokemon);
                    },
                  ),
                ),
              ],
            );
          }   
            // Load fail
          if (state is PokemonError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.message,
                  style: const TextStyle(
                    color: AppPallet.errorColor, 
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}