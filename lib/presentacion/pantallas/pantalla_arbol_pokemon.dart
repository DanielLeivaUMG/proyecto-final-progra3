import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/datos/servicios/servicio_pokeapi.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/arbol_pokemon.dart';

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
      final NodoArbolPokemon raiz = await _servicioPokeapi.obtenerArbolEvolutivo(
        pokemonBase,
      );

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
    final String nombreEliminar = _controladorEliminar.text.trim().toLowerCase();

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

  Widget _construirVistaArbol() {
    if (_arbolPokemon.estaVacio()) {
      return const Text('Aun no hay un arbol cargado.');
    }

    final List<MapEntry<NodoArbolPokemon, int>> nodosConNivel =
        _arbolPokemon.obtenerNodosConNivel();

    return Column(
      children: nodosConNivel.map((MapEntry<NodoArbolPokemon, int> entrada) {
        final NodoArbolPokemon nodo = entrada.key;
        final int nivel = entrada.value;
        return Container(
          margin: EdgeInsets.only(left: nivel * 20.0, bottom: 8),
          decoration: BoxDecoration(
            color: nodo.esTemporal
                ? Colors.orange.withValues(alpha: 0.15)
                : Colors.blue.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            dense: true,
            leading: Icon(
              nodo.esTemporal ? Icons.edit_note_rounded : Icons.pets_rounded,
              color: nodo.esTemporal ? Colors.orange.shade700 : Colors.blue,
            ),
            title: Text(nodo.pokemon.nombre),
            subtitle: Text('Nivel ${nivel + 1}'),
            trailing: nodo.esTemporal
                ? const Text(
                    'LOCAL',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _construirTituloSeccion(String texto, IconData icono) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icono, color: Colors.teal.shade700),
          const SizedBox(width: 8),
          Text(
            texto,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _construirSeccionAnalisis() {
    if (_arbolPokemon.estaVacio()) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: const Text('Carga un arbol para ver su analisis.'),
        ),
      );
    }

    final String nombreRaiz = _arbolPokemon.raiz?.pokemon.nombre ?? '-';
    final int totalNodos = _arbolPokemon.contarNodos();
    final int profundidadMaxima = _arbolPokemon.calcularProfundidadMaxima();
    final int evolucionesDirectas =
        _arbolPokemon.obtenerCantidadEvolucionesDirectasDeRaiz();
    final String tipoArbol = _arbolPokemon.esArbolRamificado()
        ? 'Ramificado'
        : 'Lineal';
    final List<Pokemon> evolucionesFinales = _arbolPokemon.obtenerEvolucionesFinales();
    final List<Pokemon> rutaUltimaBusqueda = _ultimoNombreBuscado == null
        ? <Pokemon>[]
        : _arbolPokemon.obtenerRutaHastaPokemon(_ultimoNombreBuscado!);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analisis del arbol evolutivo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Pokemon raiz: $nombreRaiz'),
            Text('Total de nodos: $totalNodos'),
            Text('Profundidad maxima: $profundidadMaxima'),
            Text('Cantidad de evoluciones directas: $evolucionesDirectas'),
            Text('Tipo de arbol: $tipoArbol'),
            const SizedBox(height: 8),
            Text(
              'Evoluciones finales: ${evolucionesFinales.isEmpty ? "Sin datos" : evolucionesFinales.map((Pokemon pokemon) => pokemon.nombre).join(", ")}',
            ),
            const SizedBox(height: 8),
            if (_ultimoNombreBuscado == null)
              const Text('Ruta del ultimo Pokemon buscado: sin busqueda.')
            else if (rutaUltimaBusqueda.isEmpty)
              Text(
                'Ruta del ultimo Pokemon buscado ($_ultimoNombreBuscado): no existe en el arbol.',
              )
            else
              Text(
                'Ruta del ultimo Pokemon buscado ($_ultimoNombreBuscado): ${rutaUltimaBusqueda.map((Pokemon pokemon) => pokemon.nombre).join(" -> ")}',
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arbol Evolutivo Pokemon'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _construirTituloSeccion(
              'Operaciones del arbol evolutivo',
              Icons.construction_rounded,
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cargar arbol desde PokeAPI',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controladorCarga,
                      decoration: InputDecoration(
                        labelText: 'Pokemon base (nombre o id)',
                        hintText: 'Ejemplo: pikachu o 25',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onSubmitted: (_) => _cargarArbolEvolutivo(),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _cargandoArbol ? null : _cargarArbolEvolutivo,
                      icon: const Icon(Icons.cloud_download_rounded),
                      label: Text(
                        _cargandoArbol ? 'Cargando...' : 'Cargar arbol',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _tituloArbol,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Buscar Pokemon en el arbol',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controladorBusqueda,
                      decoration: InputDecoration(
                        labelText: 'Nombre a buscar',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onSubmitted: (_) => _buscarPokemon(),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _buscarPokemon,
                      icon: const Icon(Icons.search_rounded),
                      label: const Text('Buscar'),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        !_seHaBuscado
                            ? 'Resultado: sin busqueda'
                            : _pokemonEncontrado == null
                            ? 'Resultado: no encontrado'
                            : 'Resultado: ${_pokemonEncontrado!.nombre}',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Insertar evolucion local',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controladorPadre,
                      decoration: InputDecoration(
                        labelText: 'Pokemon padre',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controladorNuevo,
                      decoration: InputDecoration(
                        labelText: 'Nueva evolucion',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _insertarEvolucionLocal,
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      label: const Text('Insertar local'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Eliminar nodo local',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controladorEliminar,
                      decoration: InputDecoration(
                        labelText: 'Nombre del nodo local',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onSubmitted: (_) => _eliminarNodoLocal(),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _eliminarNodoLocal,
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: const Text('Eliminar local'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            _construirTituloSeccion('Vista del arbol', Icons.account_tree_rounded),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Vista simple del arbol evolutivo',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _construirVistaArbol(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            _construirTituloSeccion('Recorridos del arbol', Icons.route_rounded),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recorrido preorden',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _recorridoPreorden.isEmpty
                          ? 'Sin datos.'
                          : _recorridoPreorden
                                .map((Pokemon pokemon) => pokemon.nombre)
                                .join(' -> '),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recorrido por niveles (${_recorridoNiveles.length})',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (_recorridoNiveles.isEmpty)
                      const Text('Sin datos.')
                    else
                      ..._recorridoNiveles.asMap().entries.map((entry) {
                        final int indiceNivel = entry.key;
                        final List<Pokemon> elementosNivel = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            'Nivel ${indiceNivel + 1}: ${elementosNivel.map((Pokemon pokemon) => pokemon.nombre).join(', ')}',
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            _construirTituloSeccion('Analisis', Icons.analytics_rounded),
            const SizedBox(height: 10),
            _construirSeccionAnalisis(),
          ],
        ),
      ),
    );
  }
}
