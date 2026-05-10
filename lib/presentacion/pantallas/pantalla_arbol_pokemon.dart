import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/datos/servicios/servicio_pokeapi.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/arbol_pokemon.dart';

class PantallaArbolPokemon extends StatefulWidget {
  const PantallaArbolPokemon({super.key});

  @override
  State<PantallaArbolPokemon> createState() => _PantallaArbolPokemonState();
}

class _PantallaArbolPokemonState extends State<PantallaArbolPokemon> {
  final ServicioPokeapi _servicioPokeapi = ServicioPokeapi();
  final TextEditingController _controladorBusqueda = TextEditingController();

  Pokemon? _pokemonEncontrado;
  bool _seHaBuscado = false;

  @override
  void dispose() {
    _controladorBusqueda.dispose();
    super.dispose();
  }

  void _buscarPokemon(ArbolPokemon arbolPokemon) {
    final String nombreBuscado = _controladorBusqueda.text.trim();

    setState(() {
      _seHaBuscado = true;

      if (nombreBuscado.isEmpty) {
        _pokemonEncontrado = null;
        _seHaBuscado = false;
      } else {
        _pokemonEncontrado = arbolPokemon.buscar(nombreBuscado);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Arbol de Pokemon'), centerTitle: true),
      body: FutureBuilder<List<Pokemon>>(
        future: _servicioPokeapi.obtenerPokemones(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final List<Pokemon> pokemones = snapshot.data ?? <Pokemon>[];
          if (pokemones.isEmpty) {
            return const Center(child: Text('No se encontraron Pokemon'));
          }

          final ArbolPokemon arbolPokemon = ArbolPokemon();
          for (final Pokemon pokemon in pokemones) {
            arbolPokemon.insertar(pokemon);
          }

          final List<List<Pokemon>> niveles = arbolPokemon.obtenerNiveles();
          final List<Pokemon> enOrden = arbolPokemon.obtenerElementosEnOrden();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _controladorBusqueda,
                  decoration: InputDecoration(
                    labelText: 'Buscar por nombre',
                    hintText: 'Ejemplo: bulbasaur',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => _buscarPokemon(arbolPokemon),
                      icon: const Icon(Icons.search),
                    ),
                  ),
                  onSubmitted: (_) => _buscarPokemon(arbolPokemon),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    !_seHaBuscado
                        ? 'Resultado: sin busqueda'
                        : _pokemonEncontrado == null
                        ? 'Resultado: no encontrado'
                        : 'Resultado: ${_pokemonEncontrado!.nombre}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Niveles del arbol (${niveles.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    children: [
                      ...niveles.asMap().entries.map((entry) {
                        final int indiceNivel = entry.key;
                        final List<Pokemon> elementosNivel = entry.value;
                        final String nombres = elementosNivel
                            .map((Pokemon pokemon) => pokemon.nombre)
                            .join(' | ');

                        return Card(
                          child: ListTile(
                            title: Text('Nivel ${indiceNivel + 1}'),
                            subtitle: Text(nombres),
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Recorrido en orden alfabetico',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                enOrden
                                    .map((Pokemon pokemon) => pokemon.nombre)
                                    .join(', '),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
