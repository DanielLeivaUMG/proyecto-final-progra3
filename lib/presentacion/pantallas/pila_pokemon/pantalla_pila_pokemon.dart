import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon_carta.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/pila_visual_pokemon.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/pila_cola/widgets/tarjeta_pokemon.dart';

class PantallaPilaPokemon extends StatefulWidget {
  const PantallaPilaPokemon({super.key});

  @override
  State<PantallaPilaPokemon> createState() => _PantallaPilaPokemonState();
}

class _PantallaPilaPokemonState extends State<PantallaPilaPokemon> {
  final PilaVisualPokemon pila = PilaVisualPokemon();
  final TextEditingController buscarController = TextEditingController();

  int indiceResaltado = -1;
  int contador = 0;

  final List<PokemonCarta> pokemones = const <PokemonCarta>[
    PokemonCarta(
      id: 1,
      nombre: 'Bulbasaur',
      tipo: 'Planta',
      imagenUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
      hp: 45,
      ataque: 49,
      defensa: 49,
      velocidad: 45,
    ),
    PokemonCarta(
      id: 4,
      nombre: 'Charmander',
      tipo: 'Fuego',
      imagenUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png',
      hp: 39,
      ataque: 52,
      defensa: 43,
      velocidad: 65,
    ),
    PokemonCarta(
      id: 7,
      nombre: 'Squirtle',
      tipo: 'Agua',
      imagenUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png',
      hp: 44,
      ataque: 48,
      defensa: 65,
      velocidad: 43,
    ),
    PokemonCarta(
      id: 25,
      nombre: 'Pikachu',
      tipo: 'Eléctrico',
      imagenUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
      hp: 35,
      ataque: 55,
      defensa: 40,
      velocidad: 90,
    ),
  ];

  void insertar() {
    final PokemonCarta pokemon = pokemones[contador % pokemones.length];

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
    final String nombre = buscarController.text.trim();

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
    final List<PokemonCarta> elementos = pila.elementos.reversed.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F2FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F2FF),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Pila - Deck Pokémon',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2B2140),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF2B2140)),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 26),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.withValues(alpha: 0.22),
                  Colors.white.withValues(alpha: 0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.catching_pokemon,
                  size: 58,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Deck de Cartas Pokémon',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2B2140),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'LIFO: el último Pokémon agregado queda arriba y sale primero.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: buscarController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Buscar Pokémon por nombre...',
                            filled: true,
                            fillColor: const Color(0xFFF7F3FF),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: buscar,
                        icon: const Icon(Icons.search),
                        label: const Text('Buscar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: insertar,
                icon: const Icon(Icons.add),
                label: const Text('Push'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              ElevatedButton.icon(
                onPressed: eliminar,
                icon: const Icon(Icons.remove),
                label: const Text('Pop'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Cartas en pila: ${pila.elementos.length}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: elementos.isEmpty
                ? const Center(
                    child: Text(
                      'La pila está vacía.\nPresiona Push para agregar cartas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 30),
                    itemCount: elementos.length,
                    itemBuilder: (BuildContext context, int index) {
                      final PokemonCarta pokemon = elementos[index];
                      final int indiceReal = pila.elementos.indexOf(pokemon);

                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.86, end: 1),
                        duration: const Duration(milliseconds: 380),
                        curve: Curves.easeOutBack,
                        builder:
                            (
                              BuildContext context,
                              double value,
                              Widget? child,
                            ) {
                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                        child: Center(
                          child: TarjetaPokemon(
                            pokemon: pokemon,
                            resaltado: indiceReal == indiceResaltado,
                            etiqueta: index == 0 ? 'TOP' : null,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
