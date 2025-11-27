import '../controller/pokemon_details_controller.dart';
import '../controller/pokemon_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/../data/models/pokemon.dart';
import '/../core/theme/app_pallet.dart';

class PokemonListItem extends StatefulWidget {
  const PokemonListItem({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  State<PokemonListItem> createState() => _PokemonListItemState();
}

class _PokemonListItemState extends State<PokemonListItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonDetailsController()
        ..getPokemonDetails(widget.pokemon),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: BlocBuilder<PokemonDetailsController, PokemonDetailsState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppPallet.greyColor,
                        ),
                        child: _builImage(state),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.pokemon.nameCapitalized,
                              style: const TextStyle(
                                color: AppPallet.whiteCcolor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),

                            //Show More Button
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  //Show details when pressed "Show More"
                  if (_isExpanded) ...[
                    const SizedBox(height: 12),
                    const Divider(),

                    if (state is PokemonDetailsInitial)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: LinearProgressIndicator(),
                      ),

                    // Show details when data is ready
                    if (state is PokemonDetailsLoaded)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildDetailItem('Height', '${state.pokemonDetails.height} dm'),
                          _buildDetailItem('Weight', '${state.pokemonDetails.weight} hg'),
                          _buildDetailItem(
                            'Abilities',
                            state.pokemonDetails.abilities.isNotEmpty
                                ? state.pokemonDetails.abilities.join(', ')
                                : 'N/A',
                          ),
                        ],
                      ),

                    if (state is PokemonDetaislError)
                    const Text(
                      'Failed to load details',
                      style: TextStyle(color: AppPallet.errorColor),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _builImage(PokemonDetailsState state) {
    
    if (state is PokemonDetailsInitial) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (state is PokemonDetailsLoaded) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          state.pokemonDetails.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.broken_image,
            color: Colors.grey,
          ),
        ),
      );
    }

    return const Icon(
      Icons.error,
      color: AppPallet.errorColor,
    );
  }

  // Helper method to build detail item widget
  Widget _buildDetailItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}
