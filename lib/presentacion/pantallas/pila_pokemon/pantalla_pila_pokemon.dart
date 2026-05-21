import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/datos/servicios/servicio_pokeapi.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon_carta.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/pila_visual_pokemon.dart';
import 'package:proyecto_final_progra3/nucleo/tema/colores_app.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/pila_cola/widgets/tarjeta_pokemon.dart';
import 'dart:math';

enum _CriterioOrdenCartas { vida, ataque, defensa, velocidad, poderTotal }

class PantallaPilaPokemon extends StatefulWidget {
  const PantallaPilaPokemon({super.key});

  @override
  State<PantallaPilaPokemon> createState() => _PantallaPilaPokemonState();
}

class _PantallaPilaPokemonState extends State<PantallaPilaPokemon> {
  static final PilaVisualPokemon _pilaCompartida = PilaVisualPokemon();

  PilaVisualPokemon get pila => _pilaCompartida;

  final ServicioPokeapi _servicioPokeapi = ServicioPokeapi();
  final TextEditingController buscarController = TextEditingController();

  int indiceResaltado = -1;
  int contador = 0;
  int paginaActual = 0;

  static const int totalPokemones = 100;
  static const int pokemonesPorPagina = 20;

  bool cargandoBusqueda = false;
  bool cargandoTodos = false;

  PokemonCarta? pokemonBuscado;
  _CriterioOrdenCartas criterioOrden = _CriterioOrdenCartas.poderTotal;

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

  final List<PokemonCarta> todosLosPokemones = <PokemonCarta>[];

  @override
  void initState() {
    super.initState();
    cargarTodosLosPokemones();
  }

  Future<void> cargarTodosLosPokemones() async {
    setState(() {
      cargandoTodos = true;
    });

    try {
      final List<Pokemon> lista = await _servicioPokeapi
          .obtenerPokemonesPaginados(limite: totalPokemones, offset: 0);

      final List<PokemonCarta> cartas = <PokemonCarta>[];

      for (final Pokemon pokemon in lista) {
        try {
          final PokemonCarta carta = await _servicioPokeapi
              .obtenerPokemonCartaDetalle(pokemon.nombre);
          cartas.add(carta);
        } catch (_) {}
      }

      if (!mounted) return;

      setState(() {
        todosLosPokemones
          ..clear()
          ..addAll(cartas);
      });
    } catch (_) {
      mostrarMensaje('No se pudieron cargar los Pokémon.', esError: true);
    } finally {
      if (mounted) {
        setState(() {
          cargandoTodos = false;
        });
      }
    }
  }

  bool _pokemonYaExiste(PokemonCarta pokemon) {
    return pila.elementos.any(
      (PokemonCarta item) =>
          item.id == pokemon.id ||
          item.nombre.toLowerCase() == pokemon.nombre.toLowerCase(),
    );
  }

  void insertar() {
    if (todosLosPokemones.isEmpty) {
      mostrarMensaje(
        'Espera a que se carguen los Pokémon disponibles.',
        esError: true,
      );
      return;
    }

    if (pila.elementos.length >= todosLosPokemones.length) {
      mostrarMensaje(
        'Ya agregaste todos los Pokémon disponibles.',
        esError: true,
      );
      return;
    }

    final Random random = Random();

    PokemonCarta? pokemonDisponible;

    int intentos = 0;

    while (pokemonDisponible == null &&
        intentos < todosLosPokemones.length * 2) {
      final PokemonCarta pokemon =
          todosLosPokemones[random.nextInt(todosLosPokemones.length)];

      if (!_pokemonYaExiste(pokemon)) {
        pokemonDisponible = pokemon;
      }

      intentos++;
    }

    if (pokemonDisponible == null) {
      mostrarMensaje(
        'No hay más Pokémon disponibles para agregar.',
        esError: true,
      );
      return;
    }

    setState(() {
      pila.push(pokemonDisponible!);
      indiceResaltado = -1;
    });

    mostrarMensaje('${pokemonDisponible.nombre} agregado al álbum.');
  }

  void eliminar() {
    setState(() {
      pila.pop();
      indiceResaltado = -1;
    });

    mostrarMensaje('Se quitó la última carta agregada.');
  }

  Future<void> buscarPokemonApi() async {
    final String nombre = buscarController.text.trim();

    if (nombre.isEmpty) {
      mostrarMensaje('Ingresa el nombre o ID de un Pokémon.', esError: true);
      return;
    }

    setState(() {
      cargandoBusqueda = true;
      pokemonBuscado = null;
      indiceResaltado = -1;
    });

    try {
      final PokemonCarta carta = await _servicioPokeapi
          .obtenerPokemonCartaDetalle(nombre);

      if (!mounted) return;

      setState(() {
        pokemonBuscado = carta;
      });

      mostrarMensaje('Pokémon encontrado: ${carta.nombre}.');
    } catch (_) {
      if (!mounted) return;

      mostrarMensaje('No se pudo encontrar ese Pokémon.', esError: true);
    } finally {
      if (mounted) {
        setState(() {
          cargandoBusqueda = false;
        });
      }
    }
  }

  void agregarPokemonBuscado() {
    final PokemonCarta? pokemon = pokemonBuscado;

    if (pokemon == null) {
      mostrarMensaje('Primero busca un Pokémon para agregarlo.', esError: true);
      return;
    }

    agregarCartaAlAlbum(pokemon);
  }

  void agregarCartaAlAlbum(PokemonCarta pokemon) {
    if (_pokemonYaExiste(pokemon)) {
      mostrarMensaje(
        '${pokemon.nombre} ya está guardado en el álbum.',
        esError: true,
      );
      return;
    }

    setState(() {
      pila.push(pokemon);
      indiceResaltado = -1;
      pokemonBuscado = null;
      buscarController.clear();
    });

    mostrarMensaje('${pokemon.nombre} agregado al álbum.');
  }

  void buscarEnPila() {
    final String nombre = buscarController.text.trim();

    setState(() {
      indiceResaltado = pila.buscarIndicePorNombre(nombre);
    });

    if (indiceResaltado == -1) {
      mostrarMensaje(
        'Ese Pokémon no está actualmente en el álbum.',
        esError: true,
      );
    } else {
      mostrarMensaje('Pokémon encontrado dentro del álbum.');
    }
  }

  List<PokemonCarta> _obtenerCartasOrdenadas() {
    final List<PokemonCarta> cartas = pila.elementos.toList();

    cartas.sort((PokemonCarta a, PokemonCarta b) {
      return _valorOrden(b).compareTo(_valorOrden(a));
    });

    return cartas;
  }

  List<PokemonCarta> _obtenerPaginaActual() {
    final int inicio = paginaActual * pokemonesPorPagina;
    final int fin = inicio + pokemonesPorPagina;

    if (inicio >= todosLosPokemones.length) {
      return <PokemonCarta>[];
    }

    return todosLosPokemones.sublist(
      inicio,
      fin > todosLosPokemones.length ? todosLosPokemones.length : fin,
    );
  }

  int _totalPaginas() {
    if (todosLosPokemones.isEmpty) return 1;

    return (todosLosPokemones.length / pokemonesPorPagina).ceil();
  }

  int _valorOrden(PokemonCarta pokemon) {
    switch (criterioOrden) {
      case _CriterioOrdenCartas.vida:
        return pokemon.hp;
      case _CriterioOrdenCartas.ataque:
        return pokemon.ataque;
      case _CriterioOrdenCartas.defensa:
        return pokemon.defensa;
      case _CriterioOrdenCartas.velocidad:
        return pokemon.velocidad;
      case _CriterioOrdenCartas.poderTotal:
        return pokemon.poderTotal;
    }
  }

  String _nombreCriterio(_CriterioOrdenCartas criterio) {
    switch (criterio) {
      case _CriterioOrdenCartas.vida:
        return 'Mayor vida';
      case _CriterioOrdenCartas.ataque:
        return 'Mayor ataque';
      case _CriterioOrdenCartas.defensa:
        return 'Mayor defensa';
      case _CriterioOrdenCartas.velocidad:
        return 'Mayor velocidad';
      case _CriterioOrdenCartas.poderTotal:
        return 'Mayor poder total';
    }
  }

  void mostrarMensaje(String mensaje, {bool esError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? Colors.red.shade700 : Colors.green.shade700,
      ),
    );
  }

  void mostrarDetalleCarta(PokemonCarta pokemon) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Material(
            color: Colors.black.withValues(alpha: 0.45),
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: TarjetaPokemon(pokemon: pokemon, etiqueta: 'Detalle'),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _cartaClickeable({
    required PokemonCarta pokemon,
    String? etiqueta,
    bool resaltado = false,
  }) {
    return GestureDetector(
      onTap: () => mostrarDetalleCarta(pokemon),
      child: TarjetaPokemon(
        pokemon: pokemon,
        etiqueta: etiqueta,
        resaltado: resaltado,
      ),
    );
  }

  @override
  void dispose() {
    buscarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: ColoresApp.fondo,
        appBar: AppBar(
          title: const Text('Cartas Pokémon'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.layers_rounded), text: 'Pila'),
              Tab(icon: Icon(Icons.photo_album_rounded), text: 'Álbum'),
              Tab(icon: Icon(Icons.catching_pokemon_rounded), text: 'Todos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _construirPestanaPila(),
            _construirPestanaAlbum(),
            _construirPestanaTodos(),
          ],
        ),
      ),
    );
  }

  Widget _construirPestanaPila() {
    final List<PokemonCarta> elementos = pila.elementos.reversed.toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'Organiza tus cartas Pokémon usando una pila. Puedes agregar cartas aleatorias, buscar Pokémon y quitar la última carta agregada.',
                style: TextStyle(fontSize: 14.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1) Buscar Pokémon',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: buscarController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_rounded),
                      labelText: 'Nombre o ID',
                      hintText: 'Ejemplo: pikachu o 25',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: (_) => buscarPokemonApi(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: cargandoBusqueda ? null : buscarPokemonApi,
                          icon: cargandoBusqueda
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.search_rounded),
                          label: const Text('Buscar Pokémon'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: buscarEnPila,
                          icon: const Icon(Icons.photo_album_rounded),
                          label: const Text('Buscar en álbum'),
                        ),
                      ),
                    ],
                  ),
                  if (pokemonBuscado != null) ...[
                    const SizedBox(height: 14),
                    Center(
                      child: _cartaClickeable(
                        pokemon: pokemonBuscado!,
                        etiqueta: 'Encontrado',
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: agregarPokemonBuscado,
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        label: const Text('Guardar en álbum'),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 10),
                    const Text(
                      'Aún no hay Pokémon buscado.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '2) Operaciones',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: insertar,
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Agregar aleatorio'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: eliminar,
                          icon: const Icon(Icons.remove_rounded),
                          label: const Text('Quitar última carta'),
                          style: FilledButton.styleFrom(
                            backgroundColor: ColoresApp.secundario,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColoresApp.primario.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Cartas guardadas: ${pila.elementos.length}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColoresApp.primario,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '3) Pokémon encontrados',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  if (elementos.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 28),
                      child: Center(
                        child: Text(
                          'Aún no hay Pokémon guardados.\nAgrega uno buscándolo o usando el botón aleatorio.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  else
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 18,
                      runSpacing: 18,
                      children: elementos.map((PokemonCarta pokemon) {
                        final int index = elementos.indexOf(pokemon);
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
                          child: _cartaClickeable(
                            pokemon: pokemon,
                            resaltado: indiceReal == indiceResaltado,
                            etiqueta: index == 0 ? 'Último' : null,
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirPestanaAlbum() {
    final List<PokemonCarta> cartasOrdenadas = _obtenerCartasOrdenadas();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'Este álbum guarda los Pokémon que has encontrado. Puedes ordenar tus cartas según sus estadísticas principales.',
                style: TextStyle(fontSize: 14.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1) Ordenar álbum',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<_CriterioOrdenCartas>(
                    value: criterioOrden,
                    decoration: InputDecoration(
                      labelText: 'Criterio de ordenamiento',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: _CriterioOrdenCartas.values.map((
                      _CriterioOrdenCartas criterio,
                    ) {
                      return DropdownMenuItem<_CriterioOrdenCartas>(
                        value: criterio,
                        child: Text(_nombreCriterio(criterio)),
                      );
                    }).toList(),
                    onChanged: (_CriterioOrdenCartas? nuevoCriterio) {
                      if (nuevoCriterio == null) return;

                      setState(() {
                        criterioOrden = nuevoCriterio;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColoresApp.secundario.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Total en álbum: ${cartasOrdenadas.length}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColoresApp.secundario,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '2) Cartas del álbum',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  if (cartasOrdenadas.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 28),
                      child: Center(
                        child: Text(
                          'Todavía no hay cartas en el álbum.\nAgrega Pokémon desde la pestaña Pila o Todos.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  else
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 18,
                      runSpacing: 18,
                      children: cartasOrdenadas.map((PokemonCarta pokemon) {
                        return _cartaClickeable(
                          pokemon: pokemon,
                          etiqueta: '${_valorOrden(pokemon)} pts',
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirPestanaTodos() {
    final List<PokemonCarta> pagina = _obtenerPaginaActual();
    final int totalPaginas = _totalPaginas();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'Explora los primeros 100 Pokémon. Se muestran paginados para mantener una navegación más ordenada.',
                style: TextStyle(fontSize: 14.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  if (cargandoTodos)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else ...[
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: paginaActual == 0
                                ? null
                                : () {
                                    setState(() {
                                      paginaActual--;
                                    });
                                  },
                            icon: const Icon(Icons.chevron_left_rounded),
                            label: const Text('Anterior'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ColoresApp.primario.withValues(
                                alpha: 0.10,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Página ${paginaActual + 1} de $totalPaginas',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColoresApp.primario,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: paginaActual >= totalPaginas - 1
                                ? null
                                : () {
                                    setState(() {
                                      paginaActual++;
                                    });
                                  },
                            icon: const Icon(Icons.chevron_right_rounded),
                            label: const Text('Siguiente'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (pagina.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 28),
                        child: Center(
                          child: Text(
                            'No hay Pokémon disponibles.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    else
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 18,
                        runSpacing: 18,
                        children: pagina.map((PokemonCarta pokemon) {
                          final bool yaGuardado = _pokemonYaExiste(pokemon);

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _cartaClickeable(
                                pokemon: pokemon,
                                etiqueta: yaGuardado ? 'Guardado' : 'Pokémon',
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 220,
                                child: FilledButton.icon(
                                  onPressed: yaGuardado
                                      ? null
                                      : () => agregarCartaAlAlbum(pokemon),
                                  icon: Icon(
                                    yaGuardado
                                        ? Icons.check_circle_rounded
                                        : Icons.add_circle_outline_rounded,
                                  ),
                                  label: Text(
                                    yaGuardado
                                        ? 'Ya está en álbum'
                                        : 'Guardar en álbum',
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
