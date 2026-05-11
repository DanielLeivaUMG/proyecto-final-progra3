import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/arbol_pokemon.dart';
import 'package:proyecto_final_progra3/nucleo/utilidades/imagen_pokemon_helper.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/arbol_pokemon/widgets/seccion_arbol.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/arbol_pokemon/widgets/tarjeta_nodo_arbol.dart';

class PestanaVistaArbol extends StatelessWidget {
  const PestanaVistaArbol({
    super.key,
    required this.estaVacio,
    required this.nodosConNivel,
    required this.nombresRutaResaltada,
    required this.nombrePokemonEncontrado,
  });

  final bool estaVacio;
  final List<MapEntry<NodoArbolPokemon, int>> nodosConNivel;
  final Set<String> nombresRutaResaltada;
  final String? nombrePokemonEncontrado;

  @override
  Widget build(BuildContext context) {
    final Map<int, List<NodoArbolPokemon>> nodosPorNivel =
        <int, List<NodoArbolPokemon>>{};
    for (final MapEntry<NodoArbolPokemon, int> entrada in nodosConNivel) {
      nodosPorNivel.putIfAbsent(entrada.value, () => <NodoArbolPokemon>[]);
      nodosPorNivel[entrada.value]!.add(entrada.key);
    }

    final List<int> nivelesOrdenados = nodosPorNivel.keys.toList()..sort();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SeccionArbol(
            texto: 'Vista del árbol',
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
                    'Vista del árbol evolutivo por niveles',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  if (!estaVacio)
                    Text(
                      'Niveles: ${nivelesOrdenados.length} · Pokémon totales: ${nodosConNivel.length}',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (!estaVacio) const SizedBox(height: 4),
                  if (!estaVacio)
                    const Text(
                      'Cada nivel representa una etapa de evolución.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  if (!estaVacio && nombrePokemonEncontrado != null)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        'Resaltado activo: ruta en amarillo y Pokémon encontrado en verde.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (estaVacio)
                    const Text('Aún no hay un árbol cargado.')
                  else
                    Column(
                      children: nivelesOrdenados.map((int nivel) {
                        final List<NodoArbolPokemon> nodosNivel =
                            nodosPorNivel[nivel]!;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nivel ${nivel + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              LayoutBuilder(
                                builder:
                                    (
                                      BuildContext context,
                                      BoxConstraints constraints,
                                    ) {
                                      int columnas = 1;
                                      if (constraints.maxWidth >= 860) {
                                        columnas = 3;
                                      } else if (constraints.maxWidth >= 560) {
                                        columnas = 2;
                                      }

                                      final double anchoTarjeta =
                                          (constraints.maxWidth -
                                              (columnas - 1) * 10) /
                                          columnas;

                                      return Wrap(
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: nodosNivel.map((
                                          NodoArbolPokemon nodo,
                                        ) {
                                          final ReferenciasImagenPokemon?
                                          referenciasImagen =
                                              ImagenPokemonHelper.obtenerReferenciasDesdeUrl(
                                                nodo.pokemon.url,
                                              );
                                          final String nombreNormalizado = nodo
                                              .pokemon
                                              .nombre
                                              .toLowerCase();
                                          final bool esRutaResaltada =
                                              nombresRutaResaltada.contains(
                                                nombreNormalizado,
                                              );
                                          final bool esNodoEncontrado =
                                              nombrePokemonEncontrado ==
                                              nombreNormalizado;
                                          return SizedBox(
                                            width: anchoTarjeta,
                                            child: TarjetaNodoArbol(
                                              nodo: nodo,
                                              nivel: nivel,
                                              esRaiz: nivel == 0,
                                              imagenUrl: referenciasImagen
                                                  ?.urlPrincipal,
                                              imagenFallbackUrl:
                                                  referenciasImagen
                                                      ?.urlFallback,
                                              esRutaResaltada: esRutaResaltada,
                                              esPokemonEncontrado:
                                                  esNodoEncontrado,
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    },
                              ),
                            ],
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
