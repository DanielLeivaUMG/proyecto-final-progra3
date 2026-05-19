import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon_coleccion.dart';

class NodoListaEnlazadaPokemon {
  NodoListaEnlazadaPokemon({required this.valor, this.siguiente});

  PokemonColeccion valor;
  NodoListaEnlazadaPokemon? siguiente;
}

class ListaEnlazadaLivingDex {
  NodoListaEnlazadaPokemon? _cabeza;
  NodoListaEnlazadaPokemon? _cola;
  int _cantidad = 0;

  bool insertarAlFinal(PokemonColeccion item) {
    if (!_puedeInsertar(item)) {
      return false;
    }

    final NodoListaEnlazadaPokemon nuevoNodo = NodoListaEnlazadaPokemon(
      valor: item,
    );

    if (_cabeza == null) {
      _cabeza = nuevoNodo;
      _cola = nuevoNodo;
    } else {
      _cola!.siguiente = nuevoNodo;
      _cola = nuevoNodo;
    }

    _cantidad++;
    return true;
  }

  bool insertarDespuesDe({
    required String referencia,
    required PokemonColeccion nuevo,
  }) {
    if (!_puedeInsertar(nuevo)) {
      return false;
    }

    final NodoListaEnlazadaPokemon? nodoReferencia = _buscarNodoPorCriterio(
      referencia,
    );
    if (nodoReferencia == null) {
      return false;
    }

    final NodoListaEnlazadaPokemon nuevoNodo = NodoListaEnlazadaPokemon(
      valor: nuevo,
      siguiente: nodoReferencia.siguiente,
    );

    nodoReferencia.siguiente = nuevoNodo;
    if (_cola == nodoReferencia) {
      _cola = nuevoNodo;
    }

    _cantidad++;
    return true;
  }

  bool eliminarPorNombreOId(String criterio) {
    final String criterioNormalizado = _normalizarNombre(criterio);
    if (criterioNormalizado.isEmpty || _cabeza == null) {
      return false;
    }

    NodoListaEnlazadaPokemon? actual = _cabeza;
    NodoListaEnlazadaPokemon? anterior;

    while (actual != null) {
      if (_coincideConCriterio(actual.valor.pokemon, criterioNormalizado)) {
        if (anterior == null) {
          _cabeza = actual.siguiente;
        } else {
          anterior.siguiente = actual.siguiente;
        }

        if (_cola == actual) {
          _cola = anterior;
        }

        _cantidad--;
        if (_cantidad == 0) {
          _cabeza = null;
          _cola = null;
        }
        return true;
      }

      anterior = actual;
      actual = actual.siguiente;
    }

    return false;
  }

  PokemonColeccion? buscarPorNombreOId(String criterio) {
    final NodoListaEnlazadaPokemon? nodo = _buscarNodoPorCriterio(criterio);
    return nodo?.valor;
  }

  List<PokemonColeccion> obtenerTodos() {
    final List<PokemonColeccion> elementos = <PokemonColeccion>[];
    NodoListaEnlazadaPokemon? actual = _cabeza;

    while (actual != null) {
      elementos.add(actual.valor);
      actual = actual.siguiente;
    }

    return elementos;
  }

  bool cambiarEstado(String criterio, EstadoColeccionPokemon nuevoEstado) {
    final NodoListaEnlazadaPokemon? nodo = _buscarNodoPorCriterio(criterio);
    if (nodo == null) {
      return false;
    }

    nodo.valor = nodo.valor.copiarCon(estado: nuevoEstado);
    return true;
  }

  PokemonColeccion? obtenerPrimero() {
    return _cabeza?.valor;
  }

  PokemonColeccion? obtenerUltimo() {
    return _cola?.valor;
  }

  int contarNodos() {
    return _cantidad;
  }

  bool estaVacia() {
    return _cabeza == null;
  }

  void limpiar() {
    _cabeza = null;
    _cola = null;
    _cantidad = 0;
  }

  NodoListaEnlazadaPokemon? _buscarNodoPorCriterio(String criterio) {
    final String criterioNormalizado = _normalizarNombre(criterio);
    if (criterioNormalizado.isEmpty) {
      return null;
    }

    NodoListaEnlazadaPokemon? actual = _cabeza;
    while (actual != null) {
      if (_coincideConCriterio(actual.valor.pokemon, criterioNormalizado)) {
        return actual;
      }
      actual = actual.siguiente;
    }

    return null;
  }

  bool _puedeInsertar(PokemonColeccion item) {
    final String nombreNormalizado = _normalizarNombre(item.pokemon.nombre);
    if (nombreNormalizado.isEmpty) {
      return false;
    }

    return !_existePokemon(item.pokemon);
  }

  bool _existePokemon(Pokemon pokemon) {
    final int? idNuevo = pokemon.id;
    final String nombreNuevo = _normalizarNombre(pokemon.nombre);

    NodoListaEnlazadaPokemon? actual = _cabeza;
    while (actual != null) {
      final Pokemon pokemonActual = actual.valor.pokemon;
      final int? idActual = pokemonActual.id;
      final String nombreActual = _normalizarNombre(pokemonActual.nombre);

      final bool duplicadoPorId =
          idNuevo != null && idActual != null && idNuevo == idActual;
      final bool duplicadoPorNombre =
          nombreNuevo.isNotEmpty && nombreNuevo == nombreActual;

      if (duplicadoPorId || duplicadoPorNombre) {
        return true;
      }

      actual = actual.siguiente;
    }

    return false;
  }

  bool _coincideConCriterio(Pokemon pokemon, String criterioNormalizado) {
    final int? idBuscado = int.tryParse(criterioNormalizado);
    if (idBuscado != null && pokemon.id != null && pokemon.id == idBuscado) {
      return true;
    }

    return _normalizarNombre(pokemon.nombre) == criterioNormalizado;
  }

  String _normalizarNombre(String valor) {
    return valor.trim().toLowerCase();
  }
}
