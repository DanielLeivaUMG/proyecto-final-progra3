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

  Color _colorTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'fuego':
        return Colors.deepOrange;
      case 'agua':
        return Colors.blue;
      case 'planta':
        return Colors.green;
      case 'eléctrico':
      case 'electrico':
        return Colors.amber;
      case 'normal':
        return Colors.brown;
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color colorTipo = _colorTipo(pokemon.tipo);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      width: 230,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorTipo.withValues(alpha: 0.18), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: resaltado ? Colors.orange : colorTipo.withValues(alpha: 0.45),
          width: resaltado ? 3 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colorTipo.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (etiqueta != null)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  etiqueta!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          Text(
            '#${pokemon.id.toString().padLeft(3, '0')}',
            style: TextStyle(color: colorTipo, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Image.network(
            pokemon.imagenUrl,
            height: 110,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) {
              return Icon(Icons.catching_pokemon, size: 90, color: colorTipo);
            },
          ),

          const SizedBox(height: 10),

          Text(
            pokemon.nombre,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: colorTipo.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              pokemon.tipo,
              style: TextStyle(color: colorTipo, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
