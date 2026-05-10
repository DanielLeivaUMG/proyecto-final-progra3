import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';

class NodoArbolPokemon {
  NodoArbolPokemon(this.pokemon);

  final Pokemon pokemon;
  NodoArbolPokemon? izquierdo;
  NodoArbolPokemon? derecho;
}

class ArbolPokemon {
  NodoArbolPokemon? _raiz;

  NodoArbolPokemon? get raiz => _raiz;

  bool estaVacio() {
    return _raiz == null;
  }

  void insertar(Pokemon pokemon) {
    _raiz = _insertarRecursivo(_raiz, pokemon);
  }

  Pokemon? buscar(String nombre) {
    final NodoArbolPokemon? nodo = _buscarNodo(
      _raiz,
      nombre.trim().toLowerCase(),
    );
    return nodo?.pokemon;
  }

  bool eliminar(String nombre) {
    final String nombreNormalizado = nombre.trim().toLowerCase();
    if (nombreNormalizado.isEmpty || buscar(nombreNormalizado) == null) {
      return false;
    }

    _raiz = _eliminarRecursivo(_raiz, nombreNormalizado);
    return true;
  }

  void limpiar() {
    _raiz = null;
  }

  List<Pokemon> obtenerElementosEnOrden() {
    final List<Pokemon> resultado = <Pokemon>[];
    _recorrerEnOrden(_raiz, resultado);
    return resultado;
  }

  List<List<Pokemon>> obtenerNiveles() {
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
        if (nodo.izquierdo != null) {
          siguienteNivel.add(nodo.izquierdo!);
        }
        if (nodo.derecho != null) {
          siguienteNivel.add(nodo.derecho!);
        }
      }

      niveles.add(elementosNivel);
      nivelActual = siguienteNivel;
    }

    return niveles;
  }

  NodoArbolPokemon _insertarRecursivo(NodoArbolPokemon? nodo, Pokemon pokemon) {
    if (nodo == null) {
      return NodoArbolPokemon(pokemon);
    }

    final String nuevoNombre = pokemon.nombre.toLowerCase();
    final String nombreActual = nodo.pokemon.nombre.toLowerCase();

    if (nuevoNombre.compareTo(nombreActual) < 0) {
      nodo.izquierdo = _insertarRecursivo(nodo.izquierdo, pokemon);
    } else if (nuevoNombre.compareTo(nombreActual) > 0) {
      nodo.derecho = _insertarRecursivo(nodo.derecho, pokemon);
    }

    return nodo;
  }

  NodoArbolPokemon? _buscarNodo(NodoArbolPokemon? nodo, String nombre) {
    if (nodo == null) {
      return null;
    }

    final String nombreActual = nodo.pokemon.nombre.toLowerCase();
    final int comparacion = nombre.compareTo(nombreActual);

    if (comparacion == 0) {
      return nodo;
    }

    if (comparacion < 0) {
      return _buscarNodo(nodo.izquierdo, nombre);
    }

    return _buscarNodo(nodo.derecho, nombre);
  }

  NodoArbolPokemon? _eliminarRecursivo(NodoArbolPokemon? nodo, String nombre) {
    if (nodo == null) {
      return null;
    }

    final String nombreActual = nodo.pokemon.nombre.toLowerCase();
    final int comparacion = nombre.compareTo(nombreActual);

    if (comparacion < 0) {
      nodo.izquierdo = _eliminarRecursivo(nodo.izquierdo, nombre);
      return nodo;
    }

    if (comparacion > 0) {
      nodo.derecho = _eliminarRecursivo(nodo.derecho, nombre);
      return nodo;
    }

    if (nodo.izquierdo == null) {
      return nodo.derecho;
    }

    if (nodo.derecho == null) {
      return nodo.izquierdo;
    }

    final NodoArbolPokemon sucesor = _obtenerMinimo(nodo.derecho!);
    nodo.derecho = _eliminarRecursivo(
      nodo.derecho,
      sucesor.pokemon.nombre.toLowerCase(),
    );

    final NodoArbolPokemon reemplazo = NodoArbolPokemon(sucesor.pokemon);
    reemplazo.izquierdo = nodo.izquierdo;
    reemplazo.derecho = nodo.derecho;

    return reemplazo;
  }

  NodoArbolPokemon _obtenerMinimo(NodoArbolPokemon nodo) {
    NodoArbolPokemon actual = nodo;
    while (actual.izquierdo != null) {
      actual = actual.izquierdo!;
    }
    return actual;
  }

  void _recorrerEnOrden(NodoArbolPokemon? nodo, List<Pokemon> acumulador) {
    if (nodo == null) {
      return;
    }

    _recorrerEnOrden(nodo.izquierdo, acumulador);
    acumulador.add(nodo.pokemon);
    _recorrerEnOrden(nodo.derecho, acumulador);
  }
}
