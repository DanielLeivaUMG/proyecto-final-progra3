import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/arbol_pokemon.dart';

class TarjetaNodoArbol extends StatelessWidget {
  const TarjetaNodoArbol({
    super.key,
    required this.nodo,
    required this.nivel,
    required this.esRaiz,
    this.esRutaResaltada = false,
    this.esPokemonEncontrado = false,
  });

  final NodoArbolPokemon nodo;
  final int nivel;
  final bool esRaiz;
  final bool esRutaResaltada;
  final bool esPokemonEncontrado;

  @override
  Widget build(BuildContext context) {
    final bool esFinal = nodo.hijos.isEmpty;
    final Color colorBase = nodo.esTemporal
        ? Colors.orange.shade700
        : Colors.blue.shade700;

    Color colorFondo = colorBase.withValues(alpha: 0.08);
    Color colorBorde = colorBase.withValues(alpha: 0.22);
    double grosorBorde = 1;
    List<BoxShadow>? sombras;

    if (esRutaResaltada) {
      colorFondo = Colors.amber.withValues(alpha: 0.18);
      colorBorde = Colors.amber.shade700.withValues(alpha: 0.55);
      grosorBorde = 1.4;
    }

    if (esPokemonEncontrado) {
      colorFondo = Colors.green.withValues(alpha: 0.16);
      colorBorde = Colors.green.shade700;
      grosorBorde = 2.2;
      sombras = <BoxShadow>[
        BoxShadow(
          color: Colors.green.withValues(alpha: 0.22),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ];
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorBorde, width: grosorBorde),
        boxShadow: sombras,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: colorBase.withValues(alpha: 0.16),
                child: Icon(
                  nodo.esTemporal
                      ? Icons.edit_note_rounded
                      : Icons.pets_rounded,
                  size: 18,
                  color: colorBase,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pokémon',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatearNombrePokemon(nodo.pokemon.nombre),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Nivel ${nivel + 1}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (esRaiz)
                const _BadgeNodoArbol(texto: 'RAÍZ', color: Color(0xFF4A3AB7)),
              if (esRutaResaltada && !esPokemonEncontrado)
                const _BadgeNodoArbol(texto: 'RUTA', color: Color(0xFF996400)),
              if (esPokemonEncontrado)
                const _BadgeNodoArbol(
                  texto: 'ENCONTRADO',
                  color: Color(0xFF1A7F44),
                ),
              if (nodo.esTemporal)
                const _BadgeNodoArbol(texto: 'LOCAL', color: Color(0xFFB26A00)),
              if (esFinal)
                const _BadgeNodoArbol(texto: 'FINAL', color: Color(0xFF157A3F)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatearNombrePokemon(String nombre) {
    if (nombre.isEmpty) {
      return nombre;
    }
    return '${nombre[0].toUpperCase()}${nombre.substring(1)}';
  }
}

class _BadgeNodoArbol extends StatelessWidget {
  const _BadgeNodoArbol({required this.texto, required this.color});

  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
