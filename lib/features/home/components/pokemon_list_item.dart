import 'package:auth_app/core/theme/app_pallet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/loading_overlay_item.dart';
import '../../../data/models/pokemon.dart';
import '../../../data/repositories/pokemon_repository.dart';
import '../../pokemon_details/controller/pokemon_single_controller.dart';
import '../../pokemon_details/controller/pokemon_single_state.dart';

class PokemonListItem extends StatelessWidget {
  const PokemonListItem({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonSingleController(
        repository: context.read<PokemonRepository>(),
        initialPokemon: pokemon,
      )..loadPokemonDetail(),

      child: const _PokemonItemView(),
    );
  }
}

class _PokemonItemView extends StatefulWidget {
  const _PokemonItemView();

  @override
  State<_PokemonItemView> createState() => _PokemonItemViewState();
}

class _PokemonItemViewState extends State<_PokemonItemView> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonSingleController, PokemonSingleState>(
      builder: (context, state) {
        final pokemon = state.pokemon;
        final hasDetail = pokemon.details != null;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
               setState(() {
                  _isExpanded = !_isExpanded;
               });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildAvatar(pokemon, state.isLoading), 
                      
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pokemon.nameCapitalized,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            
                            if (hasDetail)
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isExpanded = !_isExpanded;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        _isExpanded ? 'Hide details' : 'Show more',
                                        style: const TextStyle(
                                          color: AppPallet.showMoreCorlor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Icon(
                                        _isExpanded
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        size: 16,
                                        color: AppPallet.showMoreCorlor,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else if (state.isLoading)
                              const Text("Loading...", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Expand Section
                  if (_isExpanded && hasDetail) ...[
                    const SizedBox(height: 12),
                    const Divider(),
                    _buildDetailInfo(pokemon),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 3. Show image get from detail
  Widget _buildAvatar(Pokemon pokemon, bool isLoading) {
    // LOGIC: 
    // - If detail is available → use imgUrl from detail.
    // - If loading → show spinner.
    // - If no detail and not loading → show default icon.
    
    final details = pokemon.details;
    final imageUrl = details?.imageUrl; 

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppPallet.greyColor,
        shape: BoxShape.circle,
      ),
      child: imageUrl != null 
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            )
          : isLoading
              ? const LoadingOverlayItem()
              : const Icon(Icons.help_outline),
    );
  }

  Widget _buildDetailInfo(Pokemon pokemon) {
    final details = pokemon.details!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppPallet.borderColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _infoItem('Height', '${details.height} dm'),
          _infoItem('Weight', '${details.weight} hg'),
          _infoItem(
            'Type',
            details.abilities.isNotEmpty ? details.abilities.first : 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}