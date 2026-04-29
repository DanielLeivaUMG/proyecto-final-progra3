import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/pantalla_lista_pokemon.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/pantalla_pila_pokemon.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/pantalla_tabla_hash_pokemon.dart';

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex Estructuras'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Proyecto Final - Programación III',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Explora Pokémon reales desde la PokéAPI y visualiza estructuras de datos implementadas en Dart.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PantallaListaPokemon(),
                  ),
                );
              },
              icon: const Icon(Icons.catching_pokemon),
              label: const Text('Ver lista de Pokémon'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PantallaPilaPokemon(),
                  ),
                );
              },
              icon: const Icon(Icons.layers),
              label: const Text('Ver pila de Pokémon'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PantallaTablaHashPokemon(),
                  ),
                );
              },
              icon: const Icon(Icons.grid_view),
              label: const Text('Ver tabla hash de Pokémon'),
            ),
            const SizedBox(height: 32),
            const Text(
              'Módulos activos en esta etapa:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text('• Consumo básico de PokéAPI'),
            const Text('• Lista inicial de Pokémon'),
            const Text('• Pila con datos reales del API'),
          ],
        ),
      ),
    );
  }
}
