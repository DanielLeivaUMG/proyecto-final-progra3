import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/entidades/relaciones_danio_tipo.dart';
import 'package:proyecto_final_progra3/presentacion/widgets/chip_tipo_pokemon.dart';

class BuscadorTipoHash extends StatelessWidget {
  const BuscadorTipoHash({
    super.key,
    required this.controladorBuscarTipo,
    required this.seBuscoTipo,
    required this.tipoEncontrado,
    required this.resolverNombreTipo,
    required this.resolverRelacionesTipo,
    required this.onBuscarTipo,
  });

  final TextEditingController controladorBuscarTipo;
  final bool seBuscoTipo;
  final RelacionesDanioTipo? tipoEncontrado;
  final String Function(String tipoInterno) resolverNombreTipo;
  final RelacionesDanioTipo? Function(String tipoInterno)
  resolverRelacionesTipo;
  final VoidCallback onBuscarTipo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Buscar tipo en tabla hash',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controladorBuscarTipo,
                    decoration: InputDecoration(
                      labelText: 'Tipo',
                      hintText: 'Ejemplo: fire, water, rock',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: (_) => onBuscarTipo(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  onPressed: onBuscarTipo,
                  icon: const Icon(Icons.travel_explore_rounded),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (!seBuscoTipo)
              const Text('Resultado: sin búsqueda')
            else if (tipoEncontrado == null)
              const Text(
                'Tipo no cargado en la tabla hash. Agrega un Pokémon de ese tipo para cargarlo.',
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Tipo:',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 6),
                      ChipTipoPokemon(
                        idTipo: tipoEncontrado!.idTipo,
                        nombre: tipoEncontrado!.nombreMostrado,
                        modoBadge: true,
                        anchoBadge: 84,
                        altoBadge: 26,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _BloqueRelacionesTipos(
                    etiqueta: 'Sin daño de',
                    tipos: tipoEncontrado!.sinDanioDe,
                    resolverNombreTipo: resolverNombreTipo,
                    resolverRelacionesTipo: resolverRelacionesTipo,
                  ),
                  const SizedBox(height: 6),
                  _BloqueRelacionesTipos(
                    etiqueta: 'Medio daño de',
                    tipos: tipoEncontrado!.medioDanioDe,
                    resolverNombreTipo: resolverNombreTipo,
                    resolverRelacionesTipo: resolverRelacionesTipo,
                  ),
                  const SizedBox(height: 6),
                  _BloqueRelacionesTipos(
                    etiqueta: 'Doble daño de',
                    tipos: tipoEncontrado!.dobleDanioDe,
                    resolverNombreTipo: resolverNombreTipo,
                    resolverRelacionesTipo: resolverRelacionesTipo,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _BloqueRelacionesTipos extends StatelessWidget {
  const _BloqueRelacionesTipos({
    required this.etiqueta,
    required this.tipos,
    required this.resolverNombreTipo,
    required this.resolverRelacionesTipo,
  });

  final String etiqueta;
  final List<String> tipos;
  final String Function(String tipoInterno) resolverNombreTipo;
  final RelacionesDanioTipo? Function(String tipoInterno)
  resolverRelacionesTipo;

  @override
  Widget build(BuildContext context) {
    if (tipos.isEmpty) {
      return Text('$etiqueta: -');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$etiqueta:',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: tipos.map((String tipoInterno) {
            final RelacionesDanioTipo? relaciones = resolverRelacionesTipo(
              tipoInterno,
            );
            return ChipTipoPokemon(
              idTipo: relaciones?.idTipo,
              nombre: resolverNombreTipo(tipoInterno),
              modoBadge: true,
              compacto: true,
              anchoBadge: 74,
              altoBadge: 24,
            );
          }).toList(),
        ),
      ],
    );
  }
}
