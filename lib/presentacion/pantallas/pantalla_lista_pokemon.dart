import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/datos/servicios/servicio_pokeapi.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';

class PantallaListaPokemon extends StatelessWidget {
  const PantallaListaPokemon({super.key});

  @override
  Widget build(BuildContext context) {
    final ServicioPokeapi servicioPokeapi = ServicioPokeapi();

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Pokémon'), centerTitle: true),
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

          return ListView.builder(
            itemCount: pokemones.length,
            itemBuilder: (context, index) {
              final Pokemon pokemon = pokemones[index];

              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(pokemon.nombre),
                subtitle: Text(pokemon.url),
              );
            },
          );
        },
      ),
    );
  }
}
