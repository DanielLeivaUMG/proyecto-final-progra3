import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon_coleccion.dart';

class PestanaResumenLista extends StatelessWidget {
  const PestanaResumenLista({
    super.key,
    required this.cadena,
    required this.resolverNombreEstado,
    required this.primero,
    required this.ultimo,
    required this.totalNodos,
  });

  final List<PokemonColeccion> cadena;
  final String Function(EstadoColeccionPokemon estado) resolverNombreEstado;
  final PokemonColeccion? primero;
  final PokemonColeccion? ultimo;
  final int totalNodos;

  @override
  Widget build(BuildContext context) {
    final int capturados = _contarPorEstado(EstadoColeccionPokemon.capturado);
    final int pendientes = _contarPorEstado(EstadoColeccionPokemon.pendiente);
    final int deseados = _contarPorEstado(EstadoColeccionPokemon.deseado);
    final int intercambiables = _contarPorEstado(
      EstadoColeccionPokemon.intercambiable,
    );
    final int shiny = cadena
        .where((PokemonColeccion item) => item.esShiny)
        .length;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resumen de tu colección',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _FichaResumen(
                        titulo: 'Total de Pokémon',
                        valor: '$totalNodos',
                      ),
                      _FichaResumen(
                        titulo: 'Shiny',
                        valor: '$shiny',
                        colorFondo: Colors.amber.withValues(alpha: 0.16),
                      ),
                      _FichaResumen(
                        titulo: 'Primero en tu colección',
                        valor: primero == null
                            ? '-'
                            : _capitalizar(primero!.pokemon.nombre),
                      ),
                      _FichaResumen(
                        titulo: 'Último en tu colección',
                        valor: ultimo == null
                            ? '-'
                            : _capitalizar(ultimo!.pokemon.nombre),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estado de tu progreso',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  _FilaEstado(
                    estado: resolverNombreEstado(
                      EstadoColeccionPokemon.capturado,
                    ),
                    cantidad: capturados,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(height: 8),
                  _FilaEstado(
                    estado: resolverNombreEstado(
                      EstadoColeccionPokemon.pendiente,
                    ),
                    cantidad: pendientes,
                    color: Colors.orange.shade800,
                  ),
                  const SizedBox(height: 8),
                  _FilaEstado(
                    estado: resolverNombreEstado(
                      EstadoColeccionPokemon.deseado,
                    ),
                    cantidad: deseados,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(height: 8),
                  _FilaEstado(
                    estado: resolverNombreEstado(
                      EstadoColeccionPokemon.intercambiable,
                    ),
                    cantidad: intercambiables,
                    color: Colors.purple.shade700,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                _mensajeInterpretativo(
                  capturados: capturados,
                  pendientes: pendientes,
                  deseados: deseados,
                  intercambiables: intercambiables,
                ),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _contarPorEstado(EstadoColeccionPokemon estado) {
    return cadena
        .where((PokemonColeccion item) => item.estado == estado)
        .length;
  }

  String _mensajeInterpretativo({
    required int capturados,
    required int pendientes,
    required int deseados,
    required int intercambiables,
  }) {
    if (totalNodos == 0) {
      return 'Tu colección aún está vacía. Busca un Pokémon y agrega el primero.';
    }

    if (pendientes > capturados) {
      return 'Tu colección tiene más Pokémon pendientes que capturados. Te conviene enfocarte en completar los pendientes primero.';
    }

    if (capturados > 0 && capturados >= pendientes) {
      return 'Vas muy bien: tienes más Pokémon capturados que pendientes.';
    }

    if (deseados > intercambiables && deseados > 0) {
      return 'Tienes varios Pokémon deseados. Puedes priorizar esos para avanzar tu colección.';
    }

    if (intercambiables > 0) {
      return 'Ya tienes Pokémon marcados para intercambio. Eso puede ayudarte a completar más rápido tu colección.';
    }

    return 'Buen progreso. Sigue actualizando estados para llevar mejor control de tu colección.';
  }

  String _capitalizar(String texto) {
    if (texto.isEmpty) {
      return texto;
    }
    return '${texto[0].toUpperCase()}${texto.substring(1)}';
  }
}

class _FichaResumen extends StatelessWidget {
  const _FichaResumen({
    required this.titulo,
    required this.valor,
    this.colorFondo,
  });

  final String titulo;
  final String valor;
  final Color? colorFondo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colorFondo ?? Colors.blueGrey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 2),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _FilaEstado extends StatelessWidget {
  const _FilaEstado({
    required this.estado,
    required this.cantidad,
    required this.color,
  });

  final String estado;
  final int cantidad;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(estado)),
        Text(
          '$cantidad',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }
}
