import 'package:flutter/material.dart';
import '../../datos/modelos/modelo_pokemon.dart';

class TarjetaPokemon extends StatelessWidget {
  final Pokemon pokemon;
  final bool resaltado;
  final String? etiqueta;

  const TarjetaPokemon({
    super.key,
    required this.pokemon,
    this.resaltado = false,
    this.etiqueta,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 170,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: resaltado ? Colors.amber.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: resaltado ? Colors.orange : Colors.grey.shade300,
          width: resaltado ? 3 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (etiqueta != null)
            Text(
              etiqueta!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

          Image.network(
            pokemon.imagenUrl,
            height: 90,
            errorBuilder: (_, __, ___) {
              return const Icon(Icons.catching_pokemon, size: 80);
            },
          ),

          const SizedBox(height: 8),

          Text(
            pokemon.nombre,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          Text(pokemon.tipo, style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}
