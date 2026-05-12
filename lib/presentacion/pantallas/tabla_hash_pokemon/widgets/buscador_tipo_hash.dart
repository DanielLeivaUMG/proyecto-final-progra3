import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/entidades/relaciones_danio_tipo.dart';

class BuscadorTipoHash extends StatelessWidget {
  const BuscadorTipoHash({
    super.key,
    required this.controladorBuscarTipo,
    required this.seBuscoTipo,
    required this.tipoEncontrado,
    required this.resolverNombreTipo,
    required this.onBuscarTipo,
  });

  final TextEditingController controladorBuscarTipo;
  final bool seBuscoTipo;
  final RelacionesDanioTipo? tipoEncontrado;
  final String Function(String tipoInterno) resolverNombreTipo;
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
                  Text(
                    'Tipo: ${tipoEncontrado!.nombreMostrado}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Sin daño de: ${tipoEncontrado!.sinDanioDe.isEmpty ? "-" : tipoEncontrado!.sinDanioDe.map(resolverNombreTipo).join(", ")}',
                  ),
                  Text(
                    'Medio daño de: ${tipoEncontrado!.medioDanioDe.isEmpty ? "-" : tipoEncontrado!.medioDanioDe.map(resolverNombreTipo).join(", ")}',
                  ),
                  Text(
                    'Doble daño de: ${tipoEncontrado!.dobleDanioDe.isEmpty ? "-" : tipoEncontrado!.dobleDanioDe.map(resolverNombreTipo).join(", ")}',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
