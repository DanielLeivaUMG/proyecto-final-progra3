import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/dominio/entidades/relaciones_danio_tipo.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/tabla_hash_pokemon/widgets/buscador_tipo_hash.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/tabla_hash_pokemon/widgets/resumen_analizador_hash.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/tabla_hash_pokemon/widgets/tarjeta_pokemon_equipo.dart';

class PestanaEquipoHash extends StatelessWidget {
  const PestanaEquipoHash({
    super.key,
    required this.controladorAgregar,
    required this.controladorBuscarPokemon,
    required this.controladorBuscarTipo,
    required this.cargandoAgregar,
    required this.cantidadEquipo,
    required this.cantidadTipos,
    required this.estadoEquipo,
    required this.colorEstado,
    required this.equipo,
    required this.seBuscoPokemon,
    required this.pokemonEncontrado,
    required this.seBuscoTipo,
    required this.tipoEncontrado,
    required this.onAgregarPokemon,
    required this.onBuscarPokemon,
    required this.onBuscarTipo,
    required this.resolverNombreTipo,
    required this.onEliminarPokemon,
  });

  final TextEditingController controladorAgregar;
  final TextEditingController controladorBuscarPokemon;
  final TextEditingController controladorBuscarTipo;
  final bool cargandoAgregar;
  final int cantidadEquipo;
  final int cantidadTipos;
  final String estadoEquipo;
  final Color colorEstado;
  final List<Pokemon> equipo;
  final bool seBuscoPokemon;
  final Pokemon? pokemonEncontrado;
  final bool seBuscoTipo;
  final RelacionesDanioTipo? tipoEncontrado;
  final VoidCallback onAgregarPokemon;
  final VoidCallback onBuscarPokemon;
  final VoidCallback onBuscarTipo;
  final String Function(String tipoInterno) resolverNombreTipo;
  final ValueChanged<Pokemon> onEliminarPokemon;

  @override
  Widget build(BuildContext context) {
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
                    'Agregar Pokémon al equipo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controladorAgregar,
                          decoration: InputDecoration(
                            labelText: 'Nombre o ID',
                            hintText: 'Ejemplo: pikachu o 25',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onSubmitted: (_) => onAgregarPokemon(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilledButton.icon(
                        onPressed: cargandoAgregar ? null : onAgregarPokemon,
                        icon: cargandoAgregar
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.add),
                        label: const Text('Agregar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ResumenAnalizadorHash(
            cantidadEquipo: cantidadEquipo,
            cantidadTipos: cantidadTipos,
            estadoEquipo: estadoEquipo,
            colorEstado: colorEstado,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Buscar Pokémon en equipo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controladorBuscarPokemon,
                          decoration: InputDecoration(
                            labelText: 'Nombre o ID',
                            hintText: 'Ejemplo: charizard o 6',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onSubmitted: (_) => onBuscarPokemon(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton.filled(
                        onPressed: onBuscarPokemon,
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    !seBuscoPokemon
                        ? 'Resultado: sin búsqueda'
                        : pokemonEncontrado == null
                        ? 'Resultado: Pokémon no encontrado en el equipo.'
                        : 'Resultado: ${pokemonEncontrado!.nombre} (ID: ${pokemonEncontrado!.id ?? "-"})',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          BuscadorTipoHash(
            controladorBuscarTipo: controladorBuscarTipo,
            seBuscoTipo: seBuscoTipo,
            tipoEncontrado: tipoEncontrado,
            resolverNombreTipo: resolverNombreTipo,
            onBuscarTipo: onBuscarTipo,
          ),
          const SizedBox(height: 12),
          Text(
            'Equipo actual (${equipo.length}/6)',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (equipo.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Text(
                  'Aún no hay Pokémon en el equipo. Agrega hasta 6 para comenzar.',
                ),
              ),
            )
          else
            ...equipo.map(
              (Pokemon pokemon) => TarjetaPokemonEquipo(
                pokemon: pokemon,
                resolverNombreTipo: resolverNombreTipo,
                onEliminar: () => onEliminarPokemon(pokemon),
              ),
            ),
        ],
      ),
    );
  }
}
