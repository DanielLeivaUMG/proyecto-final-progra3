import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/datos/servicios/servicio_pokeapi.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/pila_pokemon.dart';

class PantallaPilaPokemon extends StatelessWidget {
  const PantallaPilaPokemon({super.key});

  @override
  Widget build(BuildContext context) {
    final ServicioPokeapi servicioPokeapi = ServicioPokeapi();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de exploración'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Pokemon>>(
        future: servicioPokeapi.obtenerPokemones(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final List<Pokemon> pokemones = snapshot.data ?? <Pokemon>[];

          if (pokemones.isEmpty) {
            return const Center(child: Text('No se encontraron Pokémon'));
          }

          final PilaPokemon pilaPokemon = PilaPokemon();

          for (final Pokemon pokemon in pokemones) {
            pilaPokemon.apilar(pokemon);
          }

          final List<Pokemon> elementos = pilaPokemon.obtenerElementos();

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Tope actual: ${pilaPokemon.verTope()?.nombre ?? "Sin datos"}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: elementos.length,
                  itemBuilder: (context, index) {
                    final Pokemon pokemon = elementos[index];

                    return ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(pokemon.nombre),
                      subtitle: Text(pokemon.url),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
