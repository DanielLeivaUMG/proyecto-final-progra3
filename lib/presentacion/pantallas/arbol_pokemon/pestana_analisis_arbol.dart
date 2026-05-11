import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/nucleo/utilidades/imagen_pokemon_helper.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/arbol_pokemon/widgets/seccion_arbol.dart';
import 'package:proyecto_final_progra3/presentacion/widgets/imagen_pokemon.dart';

class PestanaAnalisisArbol extends StatelessWidget {
  const PestanaAnalisisArbol({
    super.key,
    required this.estaVacio,
    required this.nombreRaiz,
    required this.totalNodos,
    required this.profundidadMaxima,
    required this.evolucionesDirectas,
    required this.tipoArbol,
    required this.evolucionesFinales,
    required this.cantidadEvolucionesLocales,
    required this.tieneBifurcacionesIntermedias,
    required this.controladorBusqueda,
    required this.seHaBuscado,
    required this.pokemonEncontrado,
    required this.onBuscarPokemon,
    required this.ultimoNombreBuscado,
    required this.rutaUltimaBusqueda,
  });

  final bool estaVacio;
  final String nombreRaiz;
  final int totalNodos;
  final int profundidadMaxima;
  final int evolucionesDirectas;
  final String tipoArbol;
  final List<Pokemon> evolucionesFinales;
  final int cantidadEvolucionesLocales;
  final bool tieneBifurcacionesIntermedias;
  final TextEditingController controladorBusqueda;
  final bool seHaBuscado;
  final Pokemon? pokemonEncontrado;
  final VoidCallback onBuscarPokemon;
  final String? ultimoNombreBuscado;
  final List<Pokemon> rutaUltimaBusqueda;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SeccionArbol(texto: 'Análisis', icono: Icons.analytics_rounded),
          const SizedBox(height: 10),
          if (estaVacio)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text('Carga una familia evolutiva para ver su resumen.'),
              ),
            )
          else ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resumen evolutivo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Este espacio resume la familia evolutiva cargada para ayudarte a interpretarla rápidamente.',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.teal.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline_rounded,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _construirMensajeInterpretacion(),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool dosColumnas = constraints.maxWidth >= 620;
                final double anchoTarjeta = dosColumnas
                    ? (constraints.maxWidth - 10) / 2
                    : constraints.maxWidth;

                final List<_MetricaResumen> metricas = <_MetricaResumen>[
                  _MetricaResumen(
                    titulo: 'Pokémon totales',
                    valor: '$totalNodos',
                    icono: Icons.catching_pokemon_rounded,
                  ),
                  _MetricaResumen(
                    titulo: 'Etapas evolutivas',
                    valor: '$profundidadMaxima',
                    icono: Icons.stacked_line_chart_rounded,
                  ),
                  _MetricaResumen(
                    titulo: 'Finales posibles',
                    valor: '${evolucionesFinales.length}',
                    icono: Icons.flag_rounded,
                  ),
                  _MetricaResumen(
                    titulo: 'Tipo de familia',
                    valor: tipoArbol,
                    icono: Icons.account_tree_rounded,
                  ),
                  _MetricaResumen(
                    titulo: 'Evoluciones simuladas',
                    valor: '$cantidadEvolucionesLocales',
                    icono: Icons.science_rounded,
                  ),
                ];

                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: metricas.map((_MetricaResumen metrica) {
                    return SizedBox(
                      width: anchoTarjeta,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Icon(metrica.icono, color: Colors.teal.shade700),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      metrica.titulo,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      metrica.valor,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Buscar ruta evolutiva',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controladorBusqueda,
                      decoration: InputDecoration(
                        labelText: 'Nombre del Pokémon',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onSubmitted: (_) => onBuscarPokemon(),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: onBuscarPokemon,
                      icon: const Icon(Icons.route_rounded),
                      label: const Text('Ver ruta'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      !seHaBuscado
                          ? 'Resultado: sin búsqueda'
                          : pokemonEncontrado == null
                          ? 'Resultado: no encontrado'
                          : 'Resultado: ${pokemonEncontrado!.nombre}',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            _construirSeccionFinalesPosibles(),
            const SizedBox(height: 12),
            _construirSeccionRutaBuscada(),
            const SizedBox(height: 12),
            _construirSeccionSimulacionesLocales(),
          ],
        ],
      ),
    );
  }

  Widget _construirSeccionFinalesPosibles() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Finales posibles',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            if (evolucionesFinales.isEmpty)
              const Text('No hay finales disponibles para mostrar.')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: evolucionesFinales
                    .map(_construirChipPokemon)
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _construirSeccionRutaBuscada() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ruta buscada',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            if (ultimoNombreBuscado == null)
              const Text(
                'Busca un Pokémon en Vista del árbol o en esta sección para ver aquí su ruta evolutiva.',
              )
            else if (rutaUltimaBusqueda.isEmpty)
              Text(
                'No se encontró una ruta hacia ${_capitalizar(ultimoNombreBuscado!)} en esta familia evolutiva.',
              )
            else ...[
              Text(
                'Ruta hacia ${_capitalizar(ultimoNombreBuscado!)}: ${rutaUltimaBusqueda.map((Pokemon pokemon) => _capitalizar(pokemon.nombre)).join(' → ')}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: rutaUltimaBusqueda
                    .map(_construirChipPokemon)
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _construirSeccionSimulacionesLocales() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Simulaciones evolutivas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            if (cantidadEvolucionesLocales == 0)
              Text(
                'No hay evoluciones simuladas en esta familia.',
                style: TextStyle(color: Colors.grey.shade700),
              )
            else ...[
              Text(
                'Hay $cantidadEvolucionesLocales evolución(es) simulada(s) en esta familia.',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                'Estas evoluciones fueron agregadas manualmente y no pertenecen a PokéAPI.',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _construirChipPokemon(Pokemon pokemon) {
    final ReferenciasImagenPokemon? referenciasImagen =
        ImagenPokemonHelper.obtenerReferenciasDesdeUrl(pokemon.url);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.teal.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImagenPokemon(
            imagenUrl: referenciasImagen?.urlPrincipal,
            imagenFallbackUrl: referenciasImagen?.urlFallback,
            tamano: 24,
            radioBorde: 6,
          ),
          const SizedBox(width: 6),
          Text(
            _capitalizar(pokemon.nombre),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _construirMensajeInterpretacion() {
    String mensaje;
    if (tipoArbol == 'Lineal') {
      mensaje =
          'Esta familia evolutiva es lineal: cada etapa lleva a una única evolución.';
    } else if (tieneBifurcacionesIntermedias) {
      mensaje =
          'Esta familia tiene bifurcaciones: algunas etapas pueden evolucionar hacia distintos finales.';
    } else if (evolucionesDirectas > 1) {
      mensaje =
          'Esta familia evolutiva es ramificada: desde una misma raíz existen varias evoluciones finales.';
    } else {
      mensaje = 'Esta familia evolutiva tiene varias rutas posibles.';
    }

    if (cantidadEvolucionesLocales > 0) {
      mensaje =
          '$mensaje Además, esta familia incluye evoluciones simuladas agregadas manualmente.';
    }
    return mensaje;
  }

  String _capitalizar(String texto) {
    if (texto.isEmpty) {
      return texto;
    }
    return '${texto[0].toUpperCase()}${texto.substring(1)}';
  }
}

class _MetricaResumen {
  const _MetricaResumen({
    required this.titulo,
    required this.valor,
    required this.icono,
  });

  final String titulo;
  final String valor;
  final IconData icono;
}
