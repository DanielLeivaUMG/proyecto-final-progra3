import 'package:flutter/material.dart';

class ResumenAnalizadorHash extends StatelessWidget {
  const ResumenAnalizadorHash({
    super.key,
    required this.cantidadEquipo,
    required this.cantidadTipos,
    required this.estadoEquipo,
    required this.colorEstado,
  });

  final int cantidadEquipo;
  final int cantidadTipos;
  final String estadoEquipo;
  final Color colorEstado;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen del analizador',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('Equipo: $cantidadEquipo/6')),
                if (estadoEquipo == 'Lleno')
                  const Chip(label: Text('Estado: Completo'))
                else
                  Chip(label: Text('Estado: $estadoEquipo')),
                Chip(
                  label: Text(
                    cantidadEquipo < 6
                        ? 'Faltan: ${6 - cantidadEquipo}'
                        : 'Listo para guardar',
                  ),
                  backgroundColor: colorEstado.withValues(alpha: 0.16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
