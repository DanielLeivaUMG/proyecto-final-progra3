import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon_coleccion.dart';
import 'package:proyecto_final_progra3/nucleo/utilidades/imagen_pokemon_helper.dart';
import 'package:proyecto_final_progra3/presentacion/widgets/chip_tipo_pokemon.dart';
import 'package:proyecto_final_progra3/presentacion/widgets/imagen_pokemon.dart';

enum _FiltroColeccion {
  todos,
  capturados,
  pendientes,
  deseados,
  intercambiables,
  shiny,
}

class PestanaCadenaLista extends StatefulWidget {
  const PestanaCadenaLista({
    super.key,
    required this.cadena,
    required this.resolverNombreEstado,
    required this.resolverIdTipo,
    required this.resolverNombreTipo,
    required this.onQuitarPokemon,
    required this.onReordenarColeccion,
  });

  final List<PokemonColeccion> cadena;
  final String Function(EstadoColeccionPokemon estado) resolverNombreEstado;
  final int? Function(String tipoInterno) resolverIdTipo;
  final String Function(String tipoInterno) resolverNombreTipo;
  final Future<bool> Function(PokemonColeccion pokemonColeccion)
  onQuitarPokemon;
  final void Function(int oldIndex, int newIndex) onReordenarColeccion;

  @override
  State<PestanaCadenaLista> createState() => _PestanaCadenaListaState();
}

class _PestanaCadenaListaState extends State<PestanaCadenaLista> {
  _FiltroColeccion _filtro = _FiltroColeccion.todos;

  @override
  Widget build(BuildContext context) {
    final List<PokemonColeccion> visibles = _obtenerFiltrados();
    final bool filtroTodos = _filtro == _FiltroColeccion.todos;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blueGrey.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Este es el orden de tu coleccion. Cada Pokemon apunta al siguiente.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chipFiltro(_FiltroColeccion.todos, 'Todos'),
                _chipFiltro(_FiltroColeccion.capturados, 'Capturados'),
                _chipFiltro(_FiltroColeccion.pendientes, 'Pendientes'),
                _chipFiltro(_FiltroColeccion.deseados, 'Deseados'),
                _chipFiltro(
                  _FiltroColeccion.intercambiables,
                  'Intercambiables',
                ),
                _chipFiltro(_FiltroColeccion.shiny, 'Shiny'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Mostrando ${visibles.length} de ${widget.cadena.length} Pokemon',
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            if (filtroTodos)
              const Text(
                'Manten presionado un Pokemon para moverlo.',
                style: TextStyle(color: Colors.black54),
              )
            else
              const Text(
                'Para reorganizar tu coleccion, usa el filtro Todos.',
                style: TextStyle(color: Colors.black54),
              ),
            const SizedBox(height: 10),
            Expanded(
              child: widget.cadena.isEmpty
                  ? const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Tu coleccion esta vacia. Agrega Pokemon desde la pestana Agregar.',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    )
                  : visibles.isEmpty
                  ? const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'No hay Pokemon para este filtro.',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    )
                  : filtroTodos
                  ? ReorderableListView.builder(
                      itemCount: visibles.length,
                      onReorder: _reordenar,
                      proxyDecorator:
                          (
                            Widget child,
                            int index,
                            Animation<double> animation,
                          ) {
                            return Material(
                              color: Colors.transparent,
                              child: child,
                            );
                          },
                      itemBuilder: (BuildContext context, int index) {
                        final PokemonColeccion item = visibles[index];
                        final bool esUltimo = index == visibles.length - 1;
                        return _construirElementoLista(
                          key: ValueKey<String>(_claveItem(item)),
                          item: item,
                          posicionMostrada: index + 1,
                          esUltimoVisible: esUltimo,
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: visibles.length,
                      itemBuilder: (BuildContext context, int index) {
                        final PokemonColeccion item = visibles[index];
                        final bool esUltimo = index == visibles.length - 1;
                        return _construirElementoLista(
                          item: item,
                          posicionMostrada: index + 1,
                          esUltimoVisible: esUltimo,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipFiltro(_FiltroColeccion filtro, String texto) {
    return ChoiceChip(
      label: Text(texto),
      selected: _filtro == filtro,
      onSelected: (_) {
        setState(() {
          _filtro = filtro;
        });
      },
    );
  }

  List<PokemonColeccion> _obtenerFiltrados() {
    switch (_filtro) {
      case _FiltroColeccion.todos:
        return List<PokemonColeccion>.from(widget.cadena);
      case _FiltroColeccion.capturados:
        return widget.cadena
            .where(
              (PokemonColeccion item) =>
                  item.estado == EstadoColeccionPokemon.capturado,
            )
            .toList();
      case _FiltroColeccion.pendientes:
        return widget.cadena
            .where(
              (PokemonColeccion item) =>
                  item.estado == EstadoColeccionPokemon.pendiente,
            )
            .toList();
      case _FiltroColeccion.deseados:
        return widget.cadena
            .where(
              (PokemonColeccion item) =>
                  item.estado == EstadoColeccionPokemon.deseado,
            )
            .toList();
      case _FiltroColeccion.intercambiables:
        return widget.cadena
            .where(
              (PokemonColeccion item) =>
                  item.estado == EstadoColeccionPokemon.intercambiable,
            )
            .toList();
      case _FiltroColeccion.shiny:
        return widget.cadena
            .where((PokemonColeccion item) => item.esShiny)
            .toList();
    }
  }

  Widget _construirElementoLista({
    Key? key,
    required PokemonColeccion item,
    required int posicionMostrada,
    required bool esUltimoVisible,
  }) {
    final ReferenciasImagenPokemon? referencias =
        ImagenPokemonHelper.obtenerReferenciasDesdeUrl(item.pokemon.url);

    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 6),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImagenPokemon(
                        imagenUrl: referencias?.urlPrincipal,
                        imagenFallbackUrl: referencias?.urlFallback,
                        tamano: 56,
                        radioBorde: 12,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Posicion $posicionMostrada',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _capitalizar(item.pokemon.nombre),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            Text('ID: ${item.pokemon.id ?? "-"}'),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            tooltip: 'Quitar de mi coleccion',
                            onPressed: () => _confirmarQuitar(item),
                            icon: const Icon(Icons.delete_outline_rounded),
                          ),
                          if (item.esShiny)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 14,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Shiny',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _colorEstado(
                            item.estado,
                          ).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          widget.resolverNombreEstado(item.estado),
                          style: TextStyle(
                            color: _colorEstado(item.estado),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (item.pokemon.tipos.isEmpty)
                        const Text(
                          'Sin tipos',
                          style: TextStyle(color: Colors.black54),
                        )
                      else
                        ...item.pokemon.tipos.map((String tipo) {
                          return ChipTipoPokemon(
                            idTipo: widget.resolverIdTipo(tipo),
                            nombre: widget.resolverNombreTipo(tipo),
                            modoBadge: true,
                            compacto: true,
                            anchoBadge: 74,
                            altoBadge: 24,
                          );
                        }),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (!esUltimoVisible)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Icon(
                Icons.keyboard_double_arrow_down_rounded,
                color: Colors.black54,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _confirmarQuitar(PokemonColeccion item) async {
    final String nombre = _capitalizar(item.pokemon.nombre);
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: Text('¿Quitar $nombre de tu coleccion?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Quitar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    await widget.onQuitarPokemon(item);
  }

  void _reordenar(int oldIndex, int newIndex) {
    widget.onReordenarColeccion(oldIndex, newIndex);
  }

  String _claveItem(PokemonColeccion item) {
    final String identificador =
        item.pokemon.id?.toString() ?? item.pokemon.nombre;
    return '$identificador-${item.fechaRegistro.microsecondsSinceEpoch}';
  }

  Color _colorEstado(EstadoColeccionPokemon estado) {
    switch (estado) {
      case EstadoColeccionPokemon.capturado:
        return Colors.green.shade700;
      case EstadoColeccionPokemon.pendiente:
        return Colors.orange.shade800;
      case EstadoColeccionPokemon.deseado:
        return Colors.blue.shade700;
      case EstadoColeccionPokemon.intercambiable:
        return Colors.purple.shade700;
    }
  }

  String _capitalizar(String texto) {
    if (texto.isEmpty) {
      return texto;
    }
    return '${texto[0].toUpperCase()}${texto.substring(1)}';
  }
}
