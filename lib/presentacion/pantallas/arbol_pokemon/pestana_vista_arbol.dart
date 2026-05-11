import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/arbol_pokemon.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/arbol_pokemon/widgets/seccion_arbol.dart';

class PestanaVistaArbol extends StatelessWidget {
  const PestanaVistaArbol({
    super.key,
    required this.estaVacio,
    required this.nodosConNivel,
  });

  final bool estaVacio;
  final List<MapEntry<NodoArbolPokemon, int>> nodosConNivel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SeccionArbol(
            texto: 'Vista del arbol',
            icono: Icons.account_tree_rounded,
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vista simple del arbol evolutivo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (estaVacio)
                    const Text('Aun no hay un arbol cargado.')
                  else
                    Column(
                      children: nodosConNivel.map((
                        MapEntry<NodoArbolPokemon, int> entrada,
                      ) {
                        final NodoArbolPokemon nodo = entrada.key;
                        final int nivel = entrada.value;
                        return Container(
                          margin: EdgeInsets.only(
                            left: nivel * 20.0,
                            bottom: 8,
                          ),
                          decoration: BoxDecoration(
                            color: nodo.esTemporal
                                ? Colors.orange.withValues(alpha: 0.15)
                                : Colors.blue.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            dense: true,
                            leading: Icon(
                              nodo.esTemporal
                                  ? Icons.edit_note_rounded
                                  : Icons.pets_rounded,
                              color: nodo.esTemporal
                                  ? Colors.orange.shade700
                                  : Colors.blue,
                            ),
                            title: Text(nodo.pokemon.nombre),
                            subtitle: Text('Nivel ${nivel + 1}'),
                            trailing: nodo.esTemporal
                                ? const Text(
                                    'LOCAL',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
