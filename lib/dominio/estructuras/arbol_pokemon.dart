import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';

class NodoArbolPokemon {
  NodoArbolPokemon({
    required this.pokemon,
    this.esTemporal = false,
    List<NodoArbolPokemon>? hijos,
  }) : hijos = hijos ?? <NodoArbolPokemon>[];

  final Pokemon pokemon;
  final bool esTemporal;
  final List<NodoArbolPokemon> hijos;
}

class ArbolPokemon {
  NodoArbolPokemon? _raiz;

  NodoArbolPokemon? get raiz => _raiz;

  void establecerRaiz(NodoArbolPokemon nuevaRaiz) {
    _raiz = nuevaRaiz;
  }

  bool estaVacio() {
    return _raiz == null;
  }

  Pokemon? buscar(String nombre) {
    final String nombreNormalizado = nombre.trim().toLowerCase();
    if (nombreNormalizado.isEmpty) {
      return null;
    }

    final NodoArbolPokemon? nodo = _buscarNodo(_raiz, nombreNormalizado);
    return nodo?.pokemon;
  }

  bool insertarEvolucionLocal({
    required String nombrePadre,
    required Pokemon pokemon,
  }) {
    final String nombrePadreNormalizado = nombrePadre.trim().toLowerCase();
    final String nuevoNombreNormalizado = pokemon.nombre.trim().toLowerCase();
    if (nombrePadreNormalizado.isEmpty || nuevoNombreNormalizado.isEmpty) {
      return false;
    }

    final NodoArbolPokemon? nodoPadre = _buscarNodo(
      _raiz,
      nombrePadreNormalizado,
    );
    if (nodoPadre == null || _buscarNodo(_raiz, nuevoNombreNormalizado) != null) {
      return false;
    }

    nodoPadre.hijos.add(
      NodoArbolPokemon(
        pokemon: Pokemon(nombre: nuevoNombreNormalizado, url: pokemon.url),
        esTemporal: true,
      ),
    );
    return true;
  }

  bool eliminarNodoLocal(String nombre) {
    final String nombreNormalizado = nombre.trim().toLowerCase();
    if (nombreNormalizado.isEmpty || _raiz == null) {
      return false;
    }

    if (_raiz!.pokemon.nombre.toLowerCase() == nombreNormalizado &&
        _raiz!.esTemporal) {
      _raiz = null;
      return true;
    }

    return _eliminarNodoLocalRecursivo(_raiz!, nombreNormalizado);
  }

  void limpiar() {
    _raiz = null;
  }

  List<Pokemon> obtenerRecorridoPreorden() {
    final List<Pokemon> resultado = <Pokemon>[];
    _recorrerPreorden(_raiz, resultado);
    return resultado;
  }

  List<List<Pokemon>> obtenerRecorridoPorNiveles() {
    final List<List<Pokemon>> niveles = <List<Pokemon>>[];
    if (_raiz == null) {
      return niveles;
    }

    List<NodoArbolPokemon> nivelActual = <NodoArbolPokemon>[_raiz!];
    while (nivelActual.isNotEmpty) {
      final List<Pokemon> elementosNivel = <Pokemon>[];
      final List<NodoArbolPokemon> siguienteNivel = <NodoArbolPokemon>[];

      for (final NodoArbolPokemon nodo in nivelActual) {
        elementosNivel.add(nodo.pokemon);
        siguienteNivel.addAll(nodo.hijos);
      }

      niveles.add(elementosNivel);
      nivelActual = siguienteNivel;
    }

    return niveles;
  }

  List<MapEntry<NodoArbolPokemon, int>> obtenerNodosConNivel() {
    final List<MapEntry<NodoArbolPokemon, int>> nodos =
        <MapEntry<NodoArbolPokemon, int>>[];
    _agregarNodosConNivel(_raiz, 0, nodos);
    return nodos;
  }

  NodoArbolPokemon? _buscarNodo(NodoArbolPokemon? nodo, String nombre) {
    if (nodo == null) {
      return null;
    }

    if (nodo.pokemon.nombre.toLowerCase() == nombre) {
      return nodo;
    }

    for (final NodoArbolPokemon hijo in nodo.hijos) {
      final NodoArbolPokemon? encontrado = _buscarNodo(hijo, nombre);
      if (encontrado != null) {
        return encontrado;
      }
    }

    return null;
  }

  bool _eliminarNodoLocalRecursivo(NodoArbolPokemon nodo, String nombre) {
    for (int indice = 0; indice < nodo.hijos.length; indice++) {
      final NodoArbolPokemon hijo = nodo.hijos[indice];
      if (hijo.pokemon.nombre.toLowerCase() == nombre) {
        if (!hijo.esTemporal) {
          return false;
        }
        nodo.hijos.removeAt(indice);
        return true;
      }

      if (_eliminarNodoLocalRecursivo(hijo, nombre)) {
        return true;
      }
    }

    return false;
  }

  void _recorrerPreorden(NodoArbolPokemon? nodo, List<Pokemon> acumulador) {
    if (nodo == null) {
      return;
    }

    acumulador.add(nodo.pokemon);
    for (final NodoArbolPokemon hijo in nodo.hijos) {
      _recorrerPreorden(hijo, acumulador);
    }
  }

  void _agregarNodosConNivel(
    NodoArbolPokemon? nodo,
    int nivel,
    List<MapEntry<NodoArbolPokemon, int>> acumulador,
  ) {
    if (nodo == null) {
      return;
    }

    acumulador.add(MapEntry<NodoArbolPokemon, int>(nodo, nivel));
    for (final NodoArbolPokemon hijo in nodo.hijos) {
      _agregarNodosConNivel(hijo, nivel + 1, acumulador);
    }
  }
}
