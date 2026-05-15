import 'package:flutter/material.dart';

import '../../datos/modelos/modelo_pokemon.dart';
import '../../dominio/estructuras/cola_pokemon.dart';
import '../widgets/tarjeta_pokemon.dart';

class PantallaCola extends StatefulWidget {
  const PantallaCola({super.key});

  @override
  State<PantallaCola> createState() => _PantallaColaState();
}

class _PantallaColaState extends State<PantallaCola> {
  final ColaPokemon cola = ColaPokemon();

  final TextEditingController buscarController = TextEditingController();

  int posicionEncontrada = -1;
  int contador = 0;

  final List<Pokemon> pokemones = const [
    Pokemon(
      id: 39,
      nombre: 'Jigglypuff',
      tipo: 'Normal',
      imagenUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/39.png',
      hp: 115,
      ataque: 45,
      defensa: 20,
      velocidad: 20,
    ),
    Pokemon(
      id: 52,
      nombre: 'Meowth',
      tipo: 'Normal',
      imagenUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/52.png',
      hp: 40,
      ataque: 45,
      defensa: 35,
      velocidad: 90,
    ),
    Pokemon(
      id: 54,
      nombre: 'Psyduck',
      tipo: 'Agua',
      imagenUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/54.png',
      hp: 50,
      ataque: 52,
      defensa: 48,
      velocidad: 55,
    ),
    Pokemon(
      id: 143,
      nombre: 'Snorlax',
      tipo: 'Normal',
      imagenUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/143.png',
      hp: 160,
      ataque: 110,
      defensa: 65,
      velocidad: 30,
    ),
  ];

  void insertar() {
    final pokemon = pokemones[contador % pokemones.length];

    setState(() {
      cola.enqueue(pokemon);
      contador++;
      posicionEncontrada = -1;
    });
  }

  void eliminar() {
    setState(() {
      cola.dequeue();
      posicionEncontrada = -1;
    });
  }

  void buscar() {
    final nombre = buscarController.text.trim();

    setState(() {
      posicionEncontrada = cola.buscarPosicion(nombre);
    });
  }

  @override
  void dispose() {
    buscarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final atacante = cola.frente;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F2FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F2FF),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Cola - Turnos de Batalla',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2B2140),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF2B2140)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'FIFO: el primer Pokémon en entrar es el primero en atacar.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // 🔥 VISTA DE BATALLA PRO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.withValues(alpha: 0.2), Colors.white],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  const Text(
                    '⚔️ Pokémon Atacando',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  atacante == null
                      ? const Text('No hay Pokémon en batalla')
                      : TarjetaPokemon(pokemon: atacante, etiqueta: 'ATACA'),
                ],
              ),
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

            if (posicionEncontrada != -1)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Está en la posición $posicionEncontrada de la cola',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: insertar,
                  icon: const Icon(Icons.add),
                  label: const Text('Enqueue'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: eliminar,
                  icon: const Icon(Icons.remove),
                  label: const Text('Dequeue'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: cola.elementos.isEmpty
                  ? const Center(child: Text('La cola está vacía'))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cola.elementos.length,
                      itemBuilder: (context, index) {
                        final pokemon = cola.elementos[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: TarjetaPokemon(
                            pokemon: pokemon,
                            resaltado: index + 1 == posicionEncontrada,
                            etiqueta: index == 0
                                ? 'PRIMERO'
                                : 'Turno ${index + 1}',
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
