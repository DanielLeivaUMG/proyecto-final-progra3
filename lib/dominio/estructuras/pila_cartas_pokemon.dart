import 'package:proyecto_final_progra3/datos/modelos/modelo_pokemon.dart';

// Pila visual de cartas Pokémon (LIFO)
class PilaCartasPokemon {
  final List<Pokemon> _elementos = [];

  List<Pokemon> get elementos => List.unmodifiable(_elementos);

  bool get estaVacia => _elementos.isEmpty;

  Pokemon? get top => estaVacia ? null : _elementos.last;

  void push(Pokemon pokemon) {
    _elementos.add(pokemon);
  }

  Pokemon? pop() {
    if (estaVacia) return null;
    return _elementos.removeLast();
  }

  int buscarIndicePorNombre(String nombre) {
    for (int i = _elementos.length - 1; i >= 0; i--) {
      if (_elementos[i].nombre.toLowerCase() == nombre.toLowerCase()) {
        return i;
      }
    }
    return -1;
  }

  void limpiar() {
    _elementos.clear();
  }
}
