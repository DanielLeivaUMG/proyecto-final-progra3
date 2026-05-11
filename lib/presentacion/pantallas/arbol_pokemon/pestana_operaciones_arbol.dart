import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/arbol_pokemon/widgets/seccion_arbol.dart';

class PestanaOperacionesArbol extends StatelessWidget {
  const PestanaOperacionesArbol({
    super.key,
    required this.controladorCarga,
    required this.controladorBusqueda,
    required this.controladorPadre,
    required this.controladorNuevo,
    required this.controladorEliminar,
    required this.cargandoArbol,
    required this.tituloArbol,
    required this.seHaBuscado,
    required this.pokemonEncontrado,
    required this.onCargarArbol,
    required this.onBuscarPokemon,
    required this.onInsertarEvolucionLocal,
    required this.onEliminarNodoLocal,
  });

  final TextEditingController controladorCarga;
  final TextEditingController controladorBusqueda;
  final TextEditingController controladorPadre;
  final TextEditingController controladorNuevo;
  final TextEditingController controladorEliminar;
  final bool cargandoArbol;
  final String tituloArbol;
  final bool seHaBuscado;
  final Pokemon? pokemonEncontrado;
  final VoidCallback onCargarArbol;
  final VoidCallback onBuscarPokemon;
  final VoidCallback onInsertarEvolucionLocal;
  final VoidCallback onEliminarNodoLocal;

  static const List<_EjemploRapidoArbol>
  _ejemplosRapidos = <_EjemploRapidoArbol>[
    _EjemploRapidoArbol(nombre: 'Eevee', descripcion: 'Muchas ramas finales'),
    _EjemploRapidoArbol(nombre: 'Charmander', descripcion: 'Evolución lineal'),
    _EjemploRapidoArbol(nombre: 'Oddish', descripcion: 'Bifurcación final'),
    _EjemploRapidoArbol(
      nombre: 'Tyrogue',
      descripcion: 'Varias finales directas',
    ),
    _EjemploRapidoArbol(nombre: 'Wurmple', descripcion: 'Ramas paralelas'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SeccionArbol(
            texto: 'Operaciones del árbol evolutivo',
            icono: Icons.construction_rounded,
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cargar árbol desde PokeAPI',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controladorCarga,
                    decoration: InputDecoration(
                      labelText: 'Pokémon base (nombre o id)',
                      hintText: 'Ejemplo: pikachu o 25',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSubmitted: (_) => onCargarArbol(),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: cargandoArbol ? null : onCargarArbol,
                    icon: const Icon(Icons.cloud_download_rounded),
                    label: Text(cargandoArbol ? 'Cargando...' : 'Cargar árbol'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ejemplos rápidos',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Carga árboles evolutivos interesantes con un toque.',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _ejemplosRapidos.map((
                      _EjemploRapidoArbol ejemplo,
                    ) {
                      return ActionChip(
                        avatar: const Icon(
                          Icons.auto_awesome_rounded,
                          size: 18,
                        ),
                        label: Text(
                          '${ejemplo.nombre} · ${ejemplo.descripcion}',
                        ),
                        onPressed: cargandoArbol
                            ? null
                            : () {
                                controladorCarga.text = ejemplo.nombre;
                                onCargarArbol();
                              },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tituloArbol,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Buscar Pokémon en el árbol',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controladorBusqueda,
                    decoration: InputDecoration(
                      labelText: 'Nombre a buscar',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSubmitted: (_) => onBuscarPokemon(),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: onBuscarPokemon,
                    icon: const Icon(Icons.search_rounded),
                    label: const Text('Buscar'),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      !seHaBuscado
                          ? 'Resultado: sin búsqueda'
                          : pokemonEncontrado == null
                          ? 'Resultado: no encontrado'
                          : 'Resultado: ${pokemonEncontrado!.nombre}',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Insertar evolución local',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controladorPadre,
                    decoration: InputDecoration(
                      labelText: 'Pokémon padre',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controladorNuevo,
                    decoration: InputDecoration(
                      labelText: 'Nueva evolución',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: onInsertarEvolucionLocal,
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    label: const Text('Insertar local'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Eliminar nodo local',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controladorEliminar,
                    decoration: InputDecoration(
                      labelText: 'Nombre del nodo local',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSubmitted: (_) => onEliminarNodoLocal(),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: onEliminarNodoLocal,
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: const Text('Eliminar local'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EjemploRapidoArbol {
  const _EjemploRapidoArbol({required this.nombre, required this.descripcion});

  final String nombre;
  final String descripcion;
}
