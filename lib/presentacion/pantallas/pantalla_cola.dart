import 'dart:math';
import 'package:flutter/material.dart';

import '../../datos/modelos/modelo_pokemon.dart';
import '../../dominio/estructuras/cola_pokemon.dart';
import '../widgets/tarjeta_pokemon.dart';

class PantallaCola extends StatefulWidget {
  const PantallaCola({super.key});

  @override
  State<PantallaCola> createState() => _PantallaColaState();
}

class _PantallaColaState extends State<PantallaCola>
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

  @override
  void initState() {
    super.initState();

    controladorAnimacion = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  void insertar() {
    final pokemon = pokemones[contador % pokemones.length];

    setState(() {
      cola.enqueue(pokemon);
      contador++;
      posicionEncontrada = -1;
      mensajeBatalla = '${pokemon.nombre} entró a la cola.';
    });
  }

  void eliminar() {
    final eliminado = cola.dequeue();

    setState(() {
      posicionEncontrada = -1;
      mensajeBatalla = eliminado == null
          ? 'No hay Pokémon en la cola.'
          : '${eliminado.nombre} salió de la cola.';
    });
  }

  void buscar() {
    final nombre = buscarController.text.trim();

    setState(() {
      posicionEncontrada = cola.buscarPosicion(nombre);
      mensajeBatalla = posicionEncontrada == -1
          ? 'No se encontró ese Pokémon.'
          : '$nombre está en la posición $posicionEncontrada.';
    });
  }

  Future<void> atacar() async {
    final atacante = cola.atacarYRotar();

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

    await Future.delayed(const Duration(milliseconds: 600));

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
    final atacante = cola.frente;
    final double porcentajeVida = vidaEnemigo / vidaMaximaEnemigo;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F2FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F2FF),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Cola - Battle System',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2B2140),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF2B2140)),
      ),
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
                    colors: [Colors.red.withValues(alpha: 0.18), Colors.white],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Text(
                      '⚔️ Vista de Batalla FIFO',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'El primero ataca y pasa al final.',
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
                            builder: (context, child) {
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
                                        color: Colors.redAccent,
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
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
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
                        fillColor: Colors.white,
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
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: eliminar,
                    icon: const Icon(Icons.remove),
                    label: const Text('Retirar'),
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
      ),
    );
  }
}

class _BarraVidaEnemigo extends StatelessWidget {
  final int vida;
  final int vidaMaxima;
  final double porcentaje;

  const _BarraVidaEnemigo({
    required this.vida,
    required this.vidaMaxima,
    required this.porcentaje,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield, color: Colors.redAccent),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(end: porcentaje),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 14,
                    backgroundColor: Colors.red.shade100,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.redAccent,
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
  final Pokemon pokemon;

  const _TarjetaBatallaPokemon({required this.pokemon});

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
            color: Colors.redAccent.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.35)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: Chip(
              label: Text('ATACA', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.redAccent,
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
