import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/dominio/entidades/relaciones_danio_tipo.dart';
import 'package:proyecto_final_progra3/nucleo/utilidades/imagen_pokemon_helper.dart';
import 'package:proyecto_final_progra3/presentacion/widgets/chip_tipo_pokemon.dart';
import 'package:proyecto_final_progra3/presentacion/widgets/imagen_pokemon.dart';

class TarjetaPokemonEquipo extends StatelessWidget {
  const TarjetaPokemonEquipo({
    super.key,
    required this.pokemon,
    required this.resolverNombreTipo,
    required this.resolverRelacionesTipo,
    required this.onEliminar,
  });

  final Pokemon pokemon;
  final String Function(String tipoInterno) resolverNombreTipo;
  final RelacionesDanioTipo? Function(String tipoInterno)
  resolverRelacionesTipo;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    final ReferenciasImagenPokemon? referencias =
        ImagenPokemonHelper.obtenerReferenciasDesdeUrl(pokemon.url);
    final String nombre = pokemon.nombre.isEmpty
        ? 'Sin nombre'
        : pokemon.nombre;

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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${pokemon.id ?? "-"}'),
            const SizedBox(height: 4),
            if (pokemon.tipos.isEmpty)
              const Text('Tipos: Sin tipos')
            else
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: pokemon.tipos.map((String tipoInterno) {
                  final RelacionesDanioTipo? relaciones =
                      resolverRelacionesTipo(tipoInterno);
                  final String nombreTipo = resolverNombreTipo(tipoInterno);
                  return ChipTipoPokemon(
                    idTipo: relaciones?.idTipo,
                    nombre: nombreTipo,
                    modoBadge: true,
                    anchoBadge: 82,
                    altoBadge: 26,
                  );
                }).toList(),
              ),
          ],
        ),
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
