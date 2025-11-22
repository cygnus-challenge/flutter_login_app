import 'package:flutter/material.dart';

import '/../data/models/pokemon.dart';
import '/../core/theme/app_pallet.dart';

class PokemonListItem extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonListItem({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    // Card
    return Card(
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  elevation: 3,
  child: Padding(
    padding: const EdgeInsets.all(12.0), 
    child: Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppPallet.greyColor,
            image: DecorationImage(
              image: NetworkImage(pokemon.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pokemon.nameCapitalized,
                style: const TextStyle(
                  color: AppPallet.whiteCcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(pokemon.url, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        
        const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16, 
          color: Colors.grey
        ),
      ],
    ),
  ),
);
  }
}
//git 