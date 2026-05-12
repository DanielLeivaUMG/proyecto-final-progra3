import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/dominio/entidades/relaciones_danio_tipo.dart';
import 'package:proyecto_final_progra3/nucleo/utilidades/imagen_pokemon_helper.dart';
import 'package:proyecto_final_progra3/presentacion/widgets/chip_tipo_pokemon.dart';
import 'package:proyecto_final_progra3/presentacion/widgets/imagen_pokemon.dart';

class TarjetaSlotEquipo extends StatelessWidget {
  const TarjetaSlotEquipo({
    super.key,
    required this.numeroSlot,
    required this.resolverNombreTipo,
    required this.resolverRelacionesTipo,
    this.pokemon,
    this.onEliminar,
  });

  final int numeroSlot;
  final Pokemon? pokemon;
  final VoidCallback? onEliminar;
  final String Function(String tipoInterno) resolverNombreTipo;
  final RelacionesDanioTipo? Function(String tipoInterno)
  resolverRelacionesTipo;

  @override
  Widget build(BuildContext context) {
    if (pokemon == null) {
      return Card(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blueGrey.withValues(alpha: 0.03),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Slot $numeroSlot',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 6),
              Icon(
                Icons.add_circle_outline_rounded,
                size: 26,
                color: Colors.grey.shade500,
              ),
              const SizedBox(height: 6),
              const Text(
                'Vacío',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 2),
              const Text(
                'Agrega Pokémon',
                style: TextStyle(fontSize: 11.5, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final ReferenciasImagenPokemon? referencias =
        ImagenPokemonHelper.obtenerReferenciasDesdeUrl(pokemon!.url);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Slot $numeroSlot',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                    color: Colors.black54,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    tooltip: 'Eliminar del equipo',
                    onPressed: onEliminar,
                    icon: const Icon(Icons.close_rounded, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Center(
              child: ImagenPokemon(
                imagenUrl: referencias?.urlPrincipal,
                imagenFallbackUrl: referencias?.urlFallback,
                tamano: 48,
                radioBorde: 12,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              pokemon!.nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(height: 1),
            Text(
              'ID: ${pokemon!.id ?? "-"}',
              style: const TextStyle(fontSize: 11.5, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            if (pokemon!.tipos.isEmpty)
              const Text(
                'Sin tipos',
                style: TextStyle(fontSize: 11.5, color: Colors.black54),
              )
            else
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: pokemon!.tipos.map((String tipoInterno) {
                  final RelacionesDanioTipo? relaciones =
                      resolverRelacionesTipo(tipoInterno);
                  return ChipTipoPokemon(
                    idTipo: relaciones?.idTipo,
                    nombre: resolverNombreTipo(tipoInterno),
                    modoBadge: true,
                    compacto: true,
                    anchoBadge: 58,
                    altoBadge: 20,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
