import 'package:flutter/material.dart';

//  usamos alias
import '../../datos/modelos/modelo_pokemon.dart' as modelo;
import '../../dominio/estructuras/pila_cartas_pokemon.dart';
import '../widgets/tarjeta_pokemon.dart';

class PantallaPila extends StatefulWidget {
  const PantallaPila({super.key});

  @override
  State<PantallaPila> createState() => _PantallaPilaState();
}

class _PantallaPilaState extends State<PantallaPila> {
  final PilaCartasPokemon pila = PilaCartasPokemon();

  final TextEditingController buscarController = TextEditingController();

  int indiceResaltado = -1;
  int contador = 0;

  final List<modelo.Pokemon> pokemones = const [
    modelo.Pokemon(
      id: 1,
      nombre: 'Bulbasaur',
      tipo: 'Planta',
      imagenUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
    ),
    modelo.Pokemon(
      id: 4,
      nombre: 'Charmander',
      tipo: 'Fuego',
      imagenUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png',
    ),
    modelo.Pokemon(
      id: 7,
      nombre: 'Squirtle',
      tipo: 'Agua',
      imagenUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png',
    ),
    modelo.Pokemon(
      id: 25,
      nombre: 'Pikachu',
      tipo: 'Eléctrico',
      imagenUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
    ),
  ];

  void insertar() {
    final pokemon = pokemones[contador % pokemones.length];

    setState(() {
      pila.push(pokemon);
      contador++;
      indiceResaltado = -1;
    });
  }

  void eliminar() {
    setState(() {
      pila.pop();
      indiceResaltado = -1;
    });
  }

  void buscar() {
    final nombre = buscarController.text.trim();

    setState(() {
      indiceResaltado = pila.buscarIndicePorNombre(nombre);
    });
  }

  @override
  void dispose() {
    buscarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elementos = pila.elementos.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pila - Deck Pokémon'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'LIFO: el último Pokémon agregado queda arriba y sale primero.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: buscarController,
                    decoration: const InputDecoration(
                      labelText: 'Buscar Pokémon',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: buscar, child: const Text('Buscar')),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: insertar,
                  icon: const Icon(Icons.add),
                  label: const Text('Push'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: eliminar,
                  icon: const Icon(Icons.remove),
                  label: const Text('Pop'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: elementos.isEmpty
                  ? const Center(child: Text('La pila está vacía'))
                  : ListView.builder(
                      itemCount: elementos.length,
                      itemBuilder: (context, index) {
                        final pokemon = elementos[index];

                        final indiceReal = pila.elementos.indexOf(pokemon);

                        return Center(
                          child: TarjetaPokemon(
                            pokemon: pokemon,
                            resaltado: indiceReal == indiceResaltado,
                            etiqueta: index == 0 ? 'TOP' : null,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
