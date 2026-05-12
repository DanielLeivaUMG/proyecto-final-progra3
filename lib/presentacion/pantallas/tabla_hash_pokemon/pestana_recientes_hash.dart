import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/entidades/equipo_guardado_pokemon.dart';

class PestanaRecientesHash extends StatelessWidget {
  const PestanaRecientesHash({
    super.key,
    required this.equiposRecientes,
    required this.cargandoOperacion,
    required this.onGuardarEquipoActual,
    required this.onCargarEquipo,
    required this.onEliminarEquipo,
    required this.onLimpiarRecientes,
  });

  final List<EquipoGuardadoPokemon> equiposRecientes;
  final bool cargandoOperacion;
  final VoidCallback onGuardarEquipoActual;
  final ValueChanged<String> onCargarEquipo;
  final ValueChanged<String> onEliminarEquipo;
  final VoidCallback onLimpiarRecientes;

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
                    'Equipos recientes',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Solo puedes guardar equipos completos de 6 Pokémon.',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: cargandoOperacion
                            ? null
                            : onGuardarEquipoActual,
                        icon: const Icon(Icons.save_alt_rounded),
                        label: const Text('Guardar equipo actual'),
                      ),
                      OutlinedButton.icon(
                        onPressed: cargandoOperacion
                            ? null
                            : onLimpiarRecientes,
                        icon: const Icon(Icons.delete_sweep_rounded),
                        label: const Text('Limpiar recientes'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (cargandoOperacion) ...[
            const SizedBox(height: 8),
            const LinearProgressIndicator(),
          ],
          const SizedBox(height: 12),
          if (equiposRecientes.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No hay equipos recientes guardados en esta sesión.',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            )
          else
            ...equiposRecientes.map((EquipoGuardadoPokemon equipo) {
              return Card(
                child: ListTile(
                  title: Text(
                    equipo.nombre,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    'Guardado: ${_formatearFechaHora(equipo.fechaGuardado)}\n'
                    'Integrantes: ${equipo.pokemones.length}/6\n'
                    'Pokémon: ${_resumenNombresPokemon(equipo)}',
                  ),
                  isThreeLine: true,
                  trailing: Wrap(
                    spacing: 6,
                    children: [
                      IconButton(
                        tooltip: 'Cargar equipo',
                        onPressed: cargandoOperacion
                            ? null
                            : () => onCargarEquipo(equipo.id),
                        icon: const Icon(Icons.upload_rounded),
                      ),
                      IconButton(
                        tooltip: 'Eliminar',
                        onPressed: cargandoOperacion
                            ? null
                            : () => onEliminarEquipo(equipo.id),
                        icon: const Icon(Icons.delete_outline_rounded),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  String _formatearFechaHora(DateTime fecha) {
    final String dia = fecha.day.toString().padLeft(2, '0');
    final String mes = fecha.month.toString().padLeft(2, '0');
    final String hora = fecha.hour.toString().padLeft(2, '0');
    final String minuto = fecha.minute.toString().padLeft(2, '0');
    return '$dia/$mes $hora:$minuto';
  }

  String _resumenNombresPokemon(EquipoGuardadoPokemon equipo) {
    final List<String> nombres = equipo.pokemones
        .map((pokemon) => pokemon.nombre.trim())
        .where((nombre) => nombre.isNotEmpty)
        .toList();

    if (nombres.isEmpty) {
      return '-';
    }

    const int limite = 4;
    final bool truncado = nombres.length > limite;
    final List<String> visibles = truncado
        ? nombres.take(limite).toList()
        : nombres;
    final String texto = visibles.join(', ');
    return truncado ? '$texto...' : texto;
  }
}
