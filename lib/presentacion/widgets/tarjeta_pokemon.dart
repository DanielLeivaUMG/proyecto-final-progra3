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
        return Colors.deepPurple;
    }
  }

  Widget _stat(String label, int value, Color color) {
    final double porcentaje = (value / 100).clamp(0.0, 1.0);

    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Container(
          width: 42,
          height: 7,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(20),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: porcentaje,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color colorTipo = _colorTipo(pokemon.tipo);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      width: 260,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorTipo.withValues(alpha: 0.28), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: resaltado ? Colors.orange : colorTipo.withValues(alpha: 0.65),
          width: resaltado ? 3 : 1.6,
        ),
        boxShadow: [
          BoxShadow(
            color: colorTipo.withValues(alpha: 0.26),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                '#${pokemon.id.toString().padLeft(3, '0')}',
                style: TextStyle(color: colorTipo, fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              if (etiqueta != null)
                Container(
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
            ],
          ),

          const SizedBox(height: 8),

          Image.network(
            pokemon.imagenUrl,
            height: 105,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) {
              return Icon(Icons.catching_pokemon, size: 85, color: colorTipo);
            },
          ),

          const SizedBox(height: 10),

          Text(
            pokemon.nombre,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1F1A2E),
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: colorTipo.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              pokemon.tipo,
              style: TextStyle(color: colorTipo, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _stat('HP', pokemon.hp, Colors.red),
                _stat('ATK', pokemon.ataque, Colors.orange),
                _stat('DEF', pokemon.defensa, Colors.blue),
                _stat('SPD', pokemon.velocidad, Colors.green),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: colorTipo.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              'Poder total: ${pokemon.poderTotal}',
              textAlign: TextAlign.center,
              style: TextStyle(color: colorTipo, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
