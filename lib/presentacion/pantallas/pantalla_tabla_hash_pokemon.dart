import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/datos/modelos/modelo_pokemon.dart';
import 'package:proyecto_final_progra3/datos/servicios/servicio_pokeapi.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/tabla_hash_pokemon.dart';

class PantallaTablaHashPokemon extends StatefulWidget {
  const PantallaTablaHashPokemon({super.key});

  @override
  State<PantallaTablaHashPokemon> createState() => _PantallaTablaHashPokemonState();
}

class _PantallaTablaHashPokemonState extends State<PantallaTablaHashPokemon> {
  final ServicioPokeapi _servicioPokeapi = ServicioPokeapi();
  final TextEditingController _controladorBusqueda = TextEditingController();

  Pokemon? _pokemonEncontrado;
  bool _seHaBuscado = false;

  @override
  void dispose() {
    _controladorBusqueda.dispose();
    super.dispose();
  }

  void _buscarPokemon(TablaHashPokemon tablaHashPokemon) {
    final String nombreBuscado = _controladorBusqueda.text.trim();

    setState(() {
      _seHaBuscado = true;

      if (nombreBuscado.isEmpty) {
        _pokemonEncontrado = null;
        _seHaBuscado = false;
      } else {
        _pokemonEncontrado = tablaHashPokemon.buscarPorNombre(nombreBuscado);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla Hash de Pokémon'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Pokemon>>(
        future: _servicioPokeapi.obtenerPokemones(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final List<Pokemon> pokemones = snapshot.data ?? <Pokemon>[];

          if (pokemones.isEmpty) {
            return const Center(
              child: Text('No se encontraron Pokémon'),
            );
          }

          final TablaHashPokemon tablaHashPokemon = TablaHashPokemon();

          for (final Pokemon pokemon in pokemones) {
            tablaHashPokemon.insertar(pokemon);
          }

          List<Pokemon> elementosMostrados = tablaHashPokemon.obtenerTodos();

          if (_seHaBuscado) {
            if (_pokemonEncontrado != null) {
              elementosMostrados = <Pokemon>[_pokemonEncontrado!];
            } else {
              elementosMostrados = <Pokemon>[];
            }
          }

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
                      onPressed: () => _buscarPokemon(tablaHashPokemon),
                      icon: const Icon(Icons.search),
                    ),
                  ),
                  onSubmitted: (_) => _buscarPokemon(tablaHashPokemon),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    !_seHaBuscado
                        ? 'Resultado: sin búsqueda'
                        : _pokemonEncontrado == null
                        ? 'Resultado: no encontrado'
                        : 'Resultado: ${_pokemonEncontrado!.nombre}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Elementos cargados: ${tablaHashPokemon.cantidad()}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: elementosMostrados.isEmpty
                      ? const Center(
                    child: Text('No hay resultados para mostrar'),
                  )
                      : ListView.builder(
                    itemCount: elementosMostrados.length,
                    itemBuilder: (context, index) {
                      final Pokemon pokemon = elementosMostrados[index];

                      return ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text(pokemon.nombre),
                        subtitle: Text('Clave: ${pokemon.nombre.toLowerCase()}'),
                      );
                    },
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
