import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';

// Pila de Pokémon (LIFO)
class PilaPokemon {
  final List<Pokemon> _elementos = [];

  List<Pokemon> get elementos => List.unmodifiable(_elementos);

  bool get estaVacia => _elementos.isEmpty;

  int get tamanio => _elementos.length;

  Pokemon? get top => estaVacia ? null : _elementos.last;

  // Método original del proyecto
  void apilar(Pokemon pokemon) {
    _elementos.add(pokemon);
  }

  // Método original del proyecto
  Pokemon? desapilar() {
    if (estaVacia) return null;
    return _elementos.removeLast();
  }

  // Método original del proyecto
  Pokemon? verTope() {
    return top;
  }

  // Método original del proyecto
  List<Pokemon> obtenerElementos() {
    return _elementos.reversed.toList();
  }

  // Métodos nuevos para nuestra pantalla visual
  void push(Pokemon pokemon) {
    apilar(pokemon);
  }

  Pokemon? pop() {
    return desapilar();
  }

  int buscarIndicePorNombre(String nombre) {
    final listaVisual = obtenerElementos();

    for (int i = 0; i < listaVisual.length; i++) {
      if (listaVisual[i].nombre.toLowerCase() == nombre.toLowerCase()) {
        return i;
      }
    }

    return -1;
  }

  void limpiar() {
    _elementos.clear();
  }
}
