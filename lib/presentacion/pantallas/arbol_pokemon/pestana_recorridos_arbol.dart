import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/arbol_pokemon/widgets/seccion_arbol.dart';

class PestanaRecorridosArbol extends StatelessWidget {
  const PestanaRecorridosArbol({
    super.key,
    required this.recorridoPreorden,
    required this.recorridoNiveles,
  });

  final List<Pokemon> recorridoPreorden;
  final List<List<Pokemon>> recorridoNiveles;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SeccionArbol(
            texto: 'Recorridos del arbol',
            icono: Icons.route_rounded,
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recorrido preorden',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recorridoPreorden.isEmpty
                        ? 'Sin datos.'
                        : recorridoPreorden
                              .map((Pokemon pokemon) => pokemon.nombre)
                              .join(' -> '),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recorrido por niveles (${recorridoNiveles.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (recorridoNiveles.isEmpty)
                    const Text('Sin datos.')
                  else
                    ...recorridoNiveles.asMap().entries.map((entry) {
                      final int indiceNivel = entry.key;
                      final List<Pokemon> elementosNivel = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          'Nivel ${indiceNivel + 1}: ${elementosNivel.map((Pokemon pokemon) => pokemon.nombre).join(', ')}',
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
