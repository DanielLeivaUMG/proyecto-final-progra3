import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';

class PilaPokemon {
  final List<Pokemon> _elementos = <Pokemon>[];

  void apilar(Pokemon pokemon) {
    _elementos.add(pokemon);
  }

  Pokemon? desapilar() {
    if (_elementos.isEmpty) {
      return null;
    }

    return _elementos.removeLast();
  }

  Pokemon? verTope() {
    if (_elementos.isEmpty) {
      return null;
    }

    return _elementos.last;
  }

  bool estaVacia() {
    return _elementos.isEmpty;
  }

  int cantidad() {
    return _elementos.length;
  }

  List<Pokemon> obtenerElementos() {
    return List<Pokemon>.from(_elementos.reversed);
  }
}
