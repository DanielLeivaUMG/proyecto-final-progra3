import 'dart:math';

import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon_carta.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/cola_pokemon.dart';
import 'package:proyecto_final_progra3/nucleo/tema/colores_app.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/pila_cola/widgets/tarjeta_pokemon.dart';

class PantallaColaPokemon extends StatefulWidget {
  const PantallaColaPokemon({super.key});

  @override
  State<PantallaColaPokemon> createState() => _PantallaColaPokemonState();
}

class _PantallaColaPokemonState extends State<PantallaColaPokemon>
    with SingleTickerProviderStateMixin {
  final ColaPokemon cola = ColaPokemon();
  final TextEditingController buscarController = TextEditingController();

  late AnimationController controladorAnimacion;

  int posicionEncontrada = -1;
  int contador = 0;

  int vidaEnemigo = 300;
  final int vidaMaximaEnemigo = 300;

  int ultimoDanio = 0;
  bool mostrarDanio = false;

  String mensajeBatalla =
      'Agrega Pokémon a la cola y presiona Atacar para iniciar.';

  final List<PokemonCarta> pokemones = const <PokemonCarta>[
    PokemonCarta(
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
    PokemonCarta(
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
    PokemonCarta(
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
    PokemonCarta(
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

  @override
  void initState() {
    super.initState();

    controladorAnimacion = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  void insertar() {
    final PokemonCarta pokemon = pokemones[contador % pokemones.length];

    setState(() {
      cola.enqueue(pokemon);
      contador++;
      posicionEncontrada = -1;
      mensajeBatalla = '${pokemon.nombre} entró a la cola.';
    });
  }

  void eliminar() {
    final PokemonCarta? eliminado = cola.dequeue();

    setState(() {
      posicionEncontrada = -1;
      mensajeBatalla = eliminado == null
          ? 'No hay Pokémon en la cola.'
          : '${eliminado.nombre} salió de la cola.';
    });
  }

  void buscar() {
    final String nombre = buscarController.text.trim();

    setState(() {
      posicionEncontrada = cola.buscarPosicion(nombre);
      mensajeBatalla = posicionEncontrada == -1
          ? 'No se encontró ese Pokémon.'
          : '$nombre está en la posición $posicionEncontrada.';
    });
  }

  Future<void> atacar() async {
    final PokemonCarta? atacante = cola.atacarYRotar();

    if (atacante == null) {
      setState(() {
        mensajeBatalla = 'No hay Pokémon para atacar.';
      });
      return;
    }

    final int danio = atacante.ataque;
    final int nuevaVida = vidaEnemigo - danio;

    setState(() {
      ultimoDanio = danio;
      mostrarDanio = true;
      posicionEncontrada = -1;
      mensajeBatalla = '${atacante.nombre} está atacando...';
    });

    await controladorAnimacion.forward(from: 0);

    setState(() {
      vidaEnemigo = nuevaVida < 0 ? 0 : nuevaVida;
      mensajeBatalla = '${atacante.nombre} hizo $danio de daño.';

      if (vidaEnemigo == 0) {
        mensajeBatalla =
            '${atacante.nombre} derrotó al enemigo. Se reinicia la batalla.';
        vidaEnemigo = vidaMaximaEnemigo;
      }
    });

    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() {
        mostrarDanio = false;
      });
    }
  }

  @override
  void dispose() {
    buscarController.dispose();
    controladorAnimacion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PokemonCarta? atacante = cola.frente;
    final double porcentajeVida = vidaEnemigo / vidaMaximaEnemigo;

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(title: const Text('Vista de Batalla')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColoresApp.secundario.withValues(alpha: 0.14),
                      ColoresApp.fondo,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Vista de Batalla',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: ColoresApp.textoPrincipal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Organiza el orden de ataque de tus Pokémon.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    _BarraVidaEnemigo(
                      vida: vidaEnemigo,
                      vidaMaxima: vidaMaximaEnemigo,
                      porcentaje: porcentajeVida,
                    ),
                    const SizedBox(height: 18),
                    atacante == null
                        ? const Padding(
                            padding: EdgeInsets.all(24),
                            child: Text('No hay Pokémon atacando'),
                          )
                        : AnimatedBuilder(
                            animation: controladorAnimacion,
                            builder: (BuildContext context, Widget? child) {
                              final double shake =
                                  sin(controladorAnimacion.value * pi * 8) * 7;

                              return Transform.translate(
                                offset: Offset(shake, 0),
                                child: child,
                              );
                            },
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                _TarjetaBatallaPokemon(pokemon: atacante),
                                AnimatedOpacity(
                                  opacity: mostrarDanio ? 1 : 0,
                                  duration: const Duration(milliseconds: 250),
                                  child: Transform.translate(
                                    offset: const Offset(0, -10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColoresApp.secundario,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '-$ultimoDanio HP',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: atacar,
                      icon: const Icon(Icons.flash_on),
                      label: const Text('Atacar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColoresApp.secundario,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 52),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      mensajeBatalla,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: buscarController,
                      decoration: InputDecoration(
                        hintText: 'Buscar Pokémon...',
                        filled: true,
                        fillColor: ColoresApp.tarjeta,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: buscar,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 52),
                    ),
                    child: const Text('Buscar'),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: insertar,
                    icon: const Icon(Icons.add),
                    label: const Text('Enviar a batalla'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 52),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: eliminar,
                    icon: const Icon(Icons.remove),
                    label: const Text('Retirar'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 52),
                      backgroundColor: ColoresApp.secundario,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 440,
                child: cola.elementos.isEmpty
                    ? const Center(child: Text('La cola está vacía'))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: cola.elementos.length,
                        itemBuilder: (BuildContext context, int index) {
                          final PokemonCarta pokemon = cola.elementos[index];

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
      ),
    );
  }
}

class _BarraVidaEnemigo extends StatelessWidget {
  const _BarraVidaEnemigo({
    required this.vida,
    required this.vidaMaxima,
    required this.porcentaje,
  });

  final int vida;
  final int vidaMaxima;
  final double porcentaje;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColoresApp.tarjeta,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield, color: ColoresApp.secundario),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(end: porcentaje),
                duration: const Duration(milliseconds: 500),
                builder: (BuildContext context, double value, Widget? child) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 14,
                    backgroundColor: ColoresApp.secundario.withValues(
                      alpha: 0.16,
                    ),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      ColoresApp.secundario,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$vida/$vidaMaxima',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _TarjetaBatallaPokemon extends StatelessWidget {
  const _TarjetaBatallaPokemon({required this.pokemon});

  final PokemonCarta pokemon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ColoresApp.secundario.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: ColoresApp.secundario.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: Chip(
              label: Text('ATACA', style: TextStyle(color: Colors.white)),
              backgroundColor: ColoresApp.secundario,
            ),
          ),
          Image.network(pokemon.imagenUrl, height: 90, fit: BoxFit.contain),
          const SizedBox(height: 8),
          Text(
            pokemon.nombre,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            pokemon.tipo,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Ataque: ${pokemon.ataque}  |  Poder: ${pokemon.poderTotal}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
