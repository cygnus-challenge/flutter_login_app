import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import Controllerr, State and Widget
import '../../../core/widgets/loading_overlay_item.dart';
import '/../core/theme/app_pallet.dart';
import '/../data/models/user.dart';
import '../controller/pokemon_list_controller.dart';
import '../controller/pokemon_list_state.dart';
import 'pokemon_list_item.dart';

class PokemonView extends StatefulWidget {
  const PokemonView({
    super.key, 
    required this.authenticatedUser
  });

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
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if ( maxScroll >= currentScroll * 0.8) {
      // Call controller to load more
      context.read<PokemonListController>().loadPokemonList();
    }
  }

  Future<void> _onRefresh() async {
    // Call controller to refresh
    context.read<PokemonListController>().refreshPokemonList();
      
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallet.backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.authenticatedUser != null
            ? 'Welcome ${widget.authenticatedUser?.username ?? ''}'
            : 'Home',
          style: TextStyle(
            color: AppPallet.homeCorlor,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppPallet.greyColor,
        foregroundColor: AppPallet.homeCorlor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: BlocBuilder<PokemonListController, PokemonListState>(
        builder: (context, state) {

          // 1. Load Init
          if (state is PokemonListInitial || state is PokemonListLoading) {
            return LoadingOverlayItem();
          }

          // 2. Load Error
          if (state is PokemonListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Icon(Icons.error_outline, size: 48, color: Colors.red),
                   const SizedBox(height: 16),
                   Text(state.errorMsg, style: const TextStyle(color: Colors.grey)),
                   TextButton(
                     onPressed: _onRefresh, 
                     child: const Text("Try again")
                   )
                ],
              ),
            );
          }

          // 3. Load Success
          if (state is PokemonListLoaded) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppPallet.gradient1,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // --- HEADER TITLE ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Text(
                        'List of Pokemon',
                        style: TextStyle(
                          color: AppPallet.errorColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // --- LIST
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        print('Here Home View: $state $context');
                        
                        if (index >= state.pokemons.length) {
                           return LoadingOverlayItem(); 
                        }

                        final pokemon = state.pokemons[index];
                        return PokemonListItem(pokemon: pokemon); 
                      },
                      
                      childCount: state.hasReachedMax
                          ? state.pokemons.length
                          : state.pokemons.length + 1,
                    ),
                  ),
                ],
              ),
            );
          }
           
          return const SizedBox();
        },
      ),
    );
  }
}