import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon_coleccion.dart';
import 'package:proyecto_final_progra3/nucleo/utilidades/imagen_pokemon_helper.dart';
import 'package:proyecto_final_progra3/presentacion/widgets/chip_tipo_pokemon.dart';
import 'package:proyecto_final_progra3/presentacion/widgets/imagen_pokemon.dart';

enum ModoUbicacionAgregar { finalColeccion, despuesDeOtro }

class PestanaOperacionesLista extends StatelessWidget {
  const PestanaOperacionesLista({
    super.key,
    required this.controladorBusquedaApi,
    required this.controladorUbicacionDespuesDe,
    required this.cargandoBusquedaApi,
    required this.pokemonApiEncontrado,
    required this.estadoParaAgregar,
    required this.esShinyParaAgregar,
    required this.modoUbicacion,
    required this.onBuscarPokemonApi,
    required this.onCambiarEstadoParaAgregar,
    required this.onCambiarShinyParaAgregar,
    required this.onCambiarModoUbicacion,
    required this.onAgregarAColeccion,
    required this.resolverNombreEstado,
    required this.resolverIdTipo,
    required this.resolverNombreTipo,
  });

  final TextEditingController controladorBusquedaApi;
  final TextEditingController controladorUbicacionDespuesDe;
  final bool cargandoBusquedaApi;
  final Pokemon? pokemonApiEncontrado;
  final EstadoColeccionPokemon estadoParaAgregar;
  final bool esShinyParaAgregar;
  final ModoUbicacionAgregar modoUbicacion;
  final VoidCallback onBuscarPokemonApi;
  final ValueChanged<EstadoColeccionPokemon> onCambiarEstadoParaAgregar;
  final ValueChanged<bool> onCambiarShinyParaAgregar;
  final ValueChanged<ModoUbicacionAgregar> onCambiarModoUbicacion;
  final VoidCallback onAgregarAColeccion;
  final String Function(EstadoColeccionPokemon estado) resolverNombreEstado;
  final int? Function(String tipoInterno) resolverIdTipo;
  final String Function(String tipoInterno) resolverNombreTipo;

  @override
  Widget build(BuildContext context) {
    final ReferenciasImagenPokemon? referenciasImagen =
        ImagenPokemonHelper.obtenerReferenciasDesdeUrl(
          pokemonApiEncontrado?.url,
        );

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'Crea tu coleccion Pokemon y marca cuales ya tienes, cuales deseas conseguir y cuales puedes intercambiar.',
                style: TextStyle(fontSize: 14.5),
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
                    '1) Buscar Pokemon',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controladorBusquedaApi,
                          decoration: InputDecoration(
                            labelText: 'Nombre o ID',
                            hintText: 'Ejemplo: pikachu o 25',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onSubmitted: (_) => onBuscarPokemonApi(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilledButton.icon(
                        onPressed: cargandoBusquedaApi
                            ? null
                            : onBuscarPokemonApi,
                        icon: cargandoBusquedaApi
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.search_rounded),
                        label: const Text('Buscar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (pokemonApiEncontrado == null)
                    const Text(
                      'Aun no hay Pokemon seleccionado.',
                      style: TextStyle(color: Colors.black54),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImagenPokemon(
                            imagenUrl: referenciasImagen?.urlPrincipal,
                            imagenFallbackUrl: referenciasImagen?.urlFallback,
                            tamano: 52,
                            radioBorde: 12,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _capitalizar(pokemonApiEncontrado!.nombre),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                Text('ID: ${pokemonApiEncontrado!.id ?? "-"}'),
                                const SizedBox(height: 4),
                                if (pokemonApiEncontrado!.tipos.isEmpty)
                                  const Text(
                                    'Sin tipos disponibles',
                                    style: TextStyle(color: Colors.black54),
                                  )
                                else
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: pokemonApiEncontrado!.tipos.map((
                                      String tipo,
                                    ) {
                                      return ChipTipoPokemon(
                                        idTipo: resolverIdTipo(tipo),
                                        nombre: resolverNombreTipo(tipo),
                                        modoBadge: true,
                                        compacto: true,
                                        anchoBadge: 74,
                                        altoBadge: 24,
                                      );
                                    }).toList(),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                    '2) Como guardarlo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: EstadoColeccionPokemon.values.map((
                      EstadoColeccionPokemon estado,
                    ) {
                      return ChoiceChip(
                        label: Text(resolverNombreEstado(estado)),
                        selected: estadoParaAgregar == estado,
                        onSelected: (_) => onCambiarEstadoParaAgregar(estado),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    value: esShinyParaAgregar,
                    onChanged: onCambiarShinyParaAgregar,
                    title: const Text('Marcar como shiny'),
                    contentPadding: EdgeInsets.zero,
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
                    '3) Ubicacion en tu coleccion',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<ModoUbicacionAgregar>(
                    showSelectedIcon: false,
                    segments: const <ButtonSegment<ModoUbicacionAgregar>>[
                      ButtonSegment<ModoUbicacionAgregar>(
                        value: ModoUbicacionAgregar.finalColeccion,
                        label: Text('Al final de mi coleccion'),
                        icon: Icon(Icons.keyboard_double_arrow_down_rounded),
                      ),
                      ButtonSegment<ModoUbicacionAgregar>(
                        value: ModoUbicacionAgregar.despuesDeOtro,
                        label: Text('Despues de otro Pokemon'),
                        icon: Icon(Icons.link_rounded),
                      ),
                    ],
                    selected: <ModoUbicacionAgregar>{modoUbicacion},
                    onSelectionChanged: (Set<ModoUbicacionAgregar> seleccion) =>
                        onCambiarModoUbicacion(seleccion.first),
                  ),
                  if (modoUbicacion == ModoUbicacionAgregar.despuesDeOtro) ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: controladorUbicacionDespuesDe,
                      decoration: InputDecoration(
                        labelText: 'Despues de que Pokemon colocarlo',
                        hintText: 'Nombre o ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: onAgregarAColeccion,
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      label: const Text('Agregar a mi coleccion'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalizar(String texto) {
    if (texto.isEmpty) {
      return texto;
    }
    return '${texto[0].toUpperCase()}${texto.substring(1)}';
  }
}
