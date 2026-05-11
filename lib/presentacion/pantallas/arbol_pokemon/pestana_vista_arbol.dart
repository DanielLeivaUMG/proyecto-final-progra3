import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/arbol_pokemon.dart';
import 'package:proyecto_final_progra3/nucleo/utilidades/imagen_pokemon_helper.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/arbol_pokemon/widgets/diagrama_arbol_pokemon.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/arbol_pokemon/widgets/seccion_arbol.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/arbol_pokemon/widgets/tarjeta_nodo_arbol.dart';

enum _ModoVistaArbol { tarjetas, diagrama }

class PestanaVistaArbol extends StatefulWidget {
  const PestanaVistaArbol({
    super.key,
    required this.estaVacio,
    required this.raiz,
    required this.nodosConNivel,
    required this.nombresRutaResaltada,
    required this.nombrePokemonEncontrado,
    required this.controladorBusqueda,
    required this.seHaBuscado,
    required this.pokemonEncontrado,
    required this.onBuscarPokemon,
  });

  final bool estaVacio;
  final NodoArbolPokemon? raiz;
  final List<MapEntry<NodoArbolPokemon, int>> nodosConNivel;
  final Set<String> nombresRutaResaltada;
  final String? nombrePokemonEncontrado;
  final TextEditingController controladorBusqueda;
  final bool seHaBuscado;
  final Pokemon? pokemonEncontrado;
  final VoidCallback onBuscarPokemon;

  @override
  State<PestanaVistaArbol> createState() => _PestanaVistaArbolState();
}

class _PestanaVistaArbolState extends State<PestanaVistaArbol> {
  _ModoVistaArbol _modoSeleccionado = _ModoVistaArbol.tarjetas;

  @override
  Widget build(BuildContext context) {
    final Map<int, List<NodoArbolPokemon>> nodosPorNivel =
        <int, List<NodoArbolPokemon>>{};
    for (final MapEntry<NodoArbolPokemon, int> entrada
        in widget.nodosConNivel) {
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
                    'Visualización del árbol evolutivo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<_ModoVistaArbol>(
                    showSelectedIcon: false,
                    segments: const <ButtonSegment<_ModoVistaArbol>>[
                      ButtonSegment<_ModoVistaArbol>(
                        value: _ModoVistaArbol.tarjetas,
                        icon: Icon(Icons.view_module_rounded),
                        label: Text('Modo Tarjetas'),
                      ),
                      ButtonSegment<_ModoVistaArbol>(
                        value: _ModoVistaArbol.diagrama,
                        icon: Icon(Icons.device_hub_rounded),
                        label: Text('Modo Diagrama'),
                      ),
                    ],
                    selected: <_ModoVistaArbol>{_modoSeleccionado},
                    onSelectionChanged: (Set<_ModoVistaArbol> seleccion) =>
                        setState(() {
                          _modoSeleccionado = seleccion.first;
                        }),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Buscar en esta familia',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: widget.controladorBusqueda,
                            decoration: InputDecoration(
                              labelText: 'Nombre del Pokémon',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onSubmitted: (_) => widget.onBuscarPokemon(),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: widget.onBuscarPokemon,
                            icon: const Icon(Icons.search_rounded),
                            label: const Text('Buscar'),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              !widget.seHaBuscado
                                  ? 'Resultado: sin búsqueda'
                                  : widget.pokemonEncontrado == null
                                  ? 'Resultado: no encontrado'
                                  : 'Resultado: ${widget.pokemonEncontrado!.nombre}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (!widget.estaVacio)
                    Text(
                      'Niveles: ${nivelesOrdenados.length} · Pokémon totales: ${widget.nodosConNivel.length}',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (!widget.estaVacio) const SizedBox(height: 4),
                  if (!widget.estaVacio)
                    Text(
                      _modoSeleccionado == _ModoVistaArbol.tarjetas
                          ? 'Cada nivel representa una etapa de evolución.'
                          : 'El diagrama muestra relaciones padre-hijo.',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  if (!widget.estaVacio &&
                      widget.nombrePokemonEncontrado != null)
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
                  if (widget.estaVacio)
                    const Text('Aún no hay un árbol cargado.')
                  else if (_modoSeleccionado == _ModoVistaArbol.tarjetas)
                    _construirModoTarjetas(nivelesOrdenados, nodosPorNivel)
                  else
                    DiagramaArbolPokemon(
                      raiz: widget.raiz!,
                      nombresRutaResaltada: widget.nombresRutaResaltada,
                      nombrePokemonEncontrado: widget.nombrePokemonEncontrado,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirModoTarjetas(
    List<int> nivelesOrdenados,
    Map<int, List<NodoArbolPokemon>> nodosPorNivel,
  ) {
    return Column(
      children: nivelesOrdenados.map((int nivel) {
        final List<NodoArbolPokemon> nodosNivel = nodosPorNivel[nivel]!;
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
                builder: (BuildContext context, BoxConstraints constraints) {
                  int columnas = 1;
                  if (constraints.maxWidth >= 860) {
                    columnas = 3;
                  } else if (constraints.maxWidth >= 560) {
                    columnas = 2;
                  }

                  final double anchoTarjeta =
                      (constraints.maxWidth - (columnas - 1) * 10) / columnas;

                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: nodosNivel.map((NodoArbolPokemon nodo) {
                      final ReferenciasImagenPokemon? referenciasImagen =
                          ImagenPokemonHelper.obtenerReferenciasDesdeUrl(
                            nodo.pokemon.url,
                          );
                      final String nombreNormalizado = nodo.pokemon.nombre
                          .toLowerCase();
                      final bool esRutaResaltada = widget.nombresRutaResaltada
                          .contains(nombreNormalizado);
                      final bool esNodoEncontrado =
                          widget.nombrePokemonEncontrado == nombreNormalizado;

                      return SizedBox(
                        width: anchoTarjeta,
                        child: TarjetaNodoArbol(
                          nodo: nodo,
                          nivel: nivel,
                          esRaiz: nivel == 0,
                          imagenUrl: referenciasImagen?.urlPrincipal,
                          imagenFallbackUrl: referenciasImagen?.urlFallback,
                          esRutaResaltada: esRutaResaltada,
                          esPokemonEncontrado: esNodoEncontrado,
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
    );
  }
}
