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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppPallet.greyColor,
          ),
          child: Image.network(pokemon.imageUrl, fit: BoxFit.fill),
        ),
        title: Text(
          pokemon.name,
          style: const TextStyle(
            color: AppPallet.whiteCcolor, 
            fontWeight: FontWeight.bold,
          )),
        subtitle: Text(pokemon.url),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16, color: Color.fromARGB(255, 158, 158, 158)
        ),
      ),
    );
  }
}