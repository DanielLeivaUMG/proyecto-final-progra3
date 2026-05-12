import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/nucleo/utilidades/imagen_pokemon_helper.dart';
import 'package:proyecto_final_progra3/presentacion/widgets/imagen_pokemon.dart';

class TarjetaPokemonEquipo extends StatelessWidget {
  const TarjetaPokemonEquipo({
    super.key,
    required this.pokemon,
    required this.onEliminar,
  });

  final Pokemon pokemon;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    final ReferenciasImagenPokemon? referencias =
        ImagenPokemonHelper.obtenerReferenciasDesdeUrl(pokemon.url);
    final String nombre = pokemon.nombre.isEmpty
        ? 'Sin nombre'
        : pokemon.nombre;
    final String tiposTexto = pokemon.tipos.isEmpty
        ? 'Sin tipos'
        : pokemon.tipos.join(', ');

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: ImagenPokemon(
          imagenUrl: referencias?.urlPrincipal,
          imagenFallbackUrl: referencias?.urlFallback,
          tamano: 52,
          radioBorde: 12,
        ),
        title: Text(
          nombre,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text('ID: ${pokemon.id ?? "-"}\nTipos: $tiposTexto'),
        isThreeLine: true,
        trailing: IconButton(
          tooltip: 'Eliminar del equipo',
          onPressed: onEliminar,
          icon: const Icon(Icons.delete_outline_rounded),
        ),
      ),
    );
  }
}
