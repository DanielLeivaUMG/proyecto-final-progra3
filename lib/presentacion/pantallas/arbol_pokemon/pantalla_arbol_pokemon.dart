import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/datos/servicios/servicio_pokeapi.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/arbol_pokemon.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/arbol_pokemon/pestana_analisis_arbol.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/arbol_pokemon/pestana_operaciones_arbol.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/arbol_pokemon/pestana_recorridos_arbol.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/arbol_pokemon/pestana_vista_arbol.dart';

class PantallaArbolPokemon extends StatefulWidget {
  const PantallaArbolPokemon({super.key});

  @override
  State<PantallaArbolPokemon> createState() => _PantallaArbolPokemonState();
}

class _PantallaArbolPokemonState extends State<PantallaArbolPokemon> {
  final ServicioPokeapi _servicioPokeapi = ServicioPokeapi();
  final ArbolPokemon _arbolPokemon = ArbolPokemon();

  final TextEditingController _controladorCarga = TextEditingController();
  final TextEditingController _controladorBusqueda = TextEditingController();
  final TextEditingController _controladorPadre = TextEditingController();
  final TextEditingController _controladorNuevo = TextEditingController();
  final TextEditingController _controladorEliminar = TextEditingController();

  Pokemon? _pokemonEncontrado;
  bool _seHaBuscado = false;
  bool _cargandoArbol = false;
  String _tituloArbol = 'Sin arbol evolutivo cargado';
  String? _ultimoNombreBuscado;
  List<Pokemon> _recorridoPreorden = <Pokemon>[];
  List<List<Pokemon>> _recorridoNiveles = <List<Pokemon>>[];

  @override
  void dispose() {
    _controladorCarga.dispose();
    _controladorBusqueda.dispose();
    _controladorPadre.dispose();
    _controladorNuevo.dispose();
    _controladorEliminar.dispose();
    super.dispose();
  }

  Future<void> _cargarArbolEvolutivo() async {
    final String pokemonBase = _controladorCarga.text.trim().toLowerCase();
    if (pokemonBase.isEmpty) {
      _mostrarMensaje('Debes ingresar un Pokemon para cargar su arbol.', true);
      return;
    }

    setState(() {
      _cargandoArbol = true;
    });

    try {
      final NodoArbolPokemon raiz = await _servicioPokeapi
          .obtenerArbolEvolutivo(pokemonBase);

      _arbolPokemon.establecerRaiz(raiz);
      _actualizarRecorridos();

      setState(() {
        _tituloArbol = 'Arbol evolutivo cargado desde: $pokemonBase';
        _pokemonEncontrado = null;
        _seHaBuscado = false;
        _ultimoNombreBuscado = null;
      });

      _mostrarMensaje('Arbol evolutivo cargado correctamente.', false);
    } catch (error) {
      _mostrarMensaje('Error al cargar el arbol: $error', true);
    } finally {
      if (mounted) {
        setState(() {
          _cargandoArbol = false;
        });
      }
    }
  }

  void _buscarPokemon() {
    final String nombreBuscado = _controladorBusqueda.text.trim().toLowerCase();
    if (_arbolPokemon.estaVacio()) {
      _mostrarMensaje('Primero debes cargar un arbol evolutivo.', true);
      return;
    }

    if (nombreBuscado.isEmpty) {
      _mostrarMensaje('Ingresa un nombre para buscar.', true);
      return;
    }

    final Pokemon? encontrado = _arbolPokemon.buscar(nombreBuscado);
    setState(() {
      _seHaBuscado = true;
      _pokemonEncontrado = encontrado;
      _ultimoNombreBuscado = nombreBuscado;
    });

    if (encontrado == null) {
      _mostrarMensaje('Pokemon no encontrado en el arbol.', true);
    } else {
      _mostrarMensaje('Pokemon encontrado: ${encontrado.nombre}', false);
    }
  }

  void _insertarEvolucionLocal() {
    final String nombrePadre = _controladorPadre.text.trim().toLowerCase();
    final String nombreNuevo = _controladorNuevo.text.trim().toLowerCase();

    if (_arbolPokemon.estaVacio()) {
      _mostrarMensaje('Primero debes cargar un arbol evolutivo.', true);
      return;
    }

    if (nombrePadre.isEmpty || nombreNuevo.isEmpty) {
      _mostrarMensaje('Completa padre y nuevo Pokemon.', true);
      return;
    }

    final bool exito = _arbolPokemon.insertarEvolucionLocal(
      nombrePadre: nombrePadre,
      pokemon: Pokemon(nombre: nombreNuevo, url: 'local://$nombreNuevo'),
    );

    if (!exito) {
      _mostrarMensaje(
        'No se pudo insertar. Revisa si existe el padre o si el nombre ya esta en el arbol.',
        true,
      );
      return;
    }

    _actualizarRecorridos();
    _controladorNuevo.clear();
    _mostrarMensaje('Evolucion local insertada correctamente.', false);
  }

  void _eliminarNodoLocal() {
    final String nombreEliminar = _controladorEliminar.text
        .trim()
        .toLowerCase();

    if (_arbolPokemon.estaVacio()) {
      _mostrarMensaje('Primero debes cargar un arbol evolutivo.', true);
      return;
    }

    if (nombreEliminar.isEmpty) {
      _mostrarMensaje('Ingresa un Pokemon para eliminar.', true);
      return;
    }

    final bool exito = _arbolPokemon.eliminarNodoLocal(nombreEliminar);
    if (!exito) {
      _mostrarMensaje(
        'No se pudo eliminar. Solo se eliminan nodos locales temporales.',
        true,
      );
      return;
    }

    _actualizarRecorridos();
    if (_pokemonEncontrado?.nombre == nombreEliminar) {
      setState(() {
        _pokemonEncontrado = null;
        _seHaBuscado = false;
      });
    }
    _mostrarMensaje('Nodo local eliminado correctamente.', false);
  }

  void _actualizarRecorridos() {
    setState(() {
      _recorridoPreorden = _arbolPokemon.obtenerRecorridoPreorden();
      _recorridoNiveles = _arbolPokemon.obtenerRecorridoPorNiveles();
    });
  }

  void _mostrarMensaje(String mensaje, bool esError) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? Colors.red.shade700 : Colors.green.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool estaVacio = _arbolPokemon.estaVacio();
    final List<MapEntry<NodoArbolPokemon, int>> nodosConNivel = _arbolPokemon
        .obtenerNodosConNivel();

    final String nombreRaiz = _arbolPokemon.raiz?.pokemon.nombre ?? '-';
    final int totalNodos = _arbolPokemon.contarNodos();
    final int profundidadMaxima = _arbolPokemon.calcularProfundidadMaxima();
    final int evolucionesDirectas = _arbolPokemon
        .obtenerCantidadEvolucionesDirectasDeRaiz();
    final String tipoArbol = _arbolPokemon.esArbolRamificado()
        ? 'Ramificado'
        : 'Lineal';
    final List<Pokemon> evolucionesFinales = _arbolPokemon
        .obtenerEvolucionesFinales();
    final List<Pokemon> rutaUltimaBusqueda = _ultimoNombreBuscado == null
        ? <Pokemon>[]
        : _arbolPokemon.obtenerRutaHastaPokemon(_ultimoNombreBuscado!);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Arbol Evolutivo Pokemon'),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.amberAccent,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            overlayColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.white.withValues(alpha: 0.14);
              }
              if (states.contains(WidgetState.hovered)) {
                return Colors.white.withValues(alpha: 0.08);
              }
              return null;
            }),
            splashBorderRadius: BorderRadius.circular(12),
            tabs: const [
              Tab(icon: Icon(Icons.construction_rounded), text: 'Operaciones'),
              Tab(
                icon: Icon(Icons.account_tree_rounded),
                text: 'Vista del arbol',
              ),
              Tab(icon: Icon(Icons.route_rounded), text: 'Recorridos'),
              Tab(icon: Icon(Icons.analytics_rounded), text: 'Analisis'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PestanaOperacionesArbol(
              controladorCarga: _controladorCarga,
              controladorBusqueda: _controladorBusqueda,
              controladorPadre: _controladorPadre,
              controladorNuevo: _controladorNuevo,
              controladorEliminar: _controladorEliminar,
              cargandoArbol: _cargandoArbol,
              tituloArbol: _tituloArbol,
              seHaBuscado: _seHaBuscado,
              pokemonEncontrado: _pokemonEncontrado,
              onCargarArbol: _cargarArbolEvolutivo,
              onBuscarPokemon: _buscarPokemon,
              onInsertarEvolucionLocal: _insertarEvolucionLocal,
              onEliminarNodoLocal: _eliminarNodoLocal,
            ),
            PestanaVistaArbol(
              estaVacio: estaVacio,
              nodosConNivel: nodosConNivel,
            ),
            PestanaRecorridosArbol(
              recorridoPreorden: _recorridoPreorden,
              recorridoNiveles: _recorridoNiveles,
            ),
            PestanaAnalisisArbol(
              estaVacio: estaVacio,
              nombreRaiz: nombreRaiz,
              totalNodos: totalNodos,
              profundidadMaxima: profundidadMaxima,
              evolucionesDirectas: evolucionesDirectas,
              tipoArbol: tipoArbol,
              evolucionesFinales: evolucionesFinales,
              ultimoNombreBuscado: _ultimoNombreBuscado,
              rutaUltimaBusqueda: rutaUltimaBusqueda,
            ),
          ],
        ),
      ),
    );
  }
}
