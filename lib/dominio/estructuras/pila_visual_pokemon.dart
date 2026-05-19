import 'package:proyecto_final_progra3/dominio/entidades/pokemon_carta.dart';

// Pila visual para las cartas Pokémon
class PilaVisualPokemon {
  final List<PokemonCarta> _elementos = [];

  List<PokemonCarta> get elementos => List.unmodifiable(_elementos);

  bool get estaVacia => _elementos.isEmpty;

  PokemonCarta? get top => estaVacia ? null : _elementos.last;

  void push(PokemonCarta pokemon) {
    _elementos.add(pokemon);
  }

  PokemonCarta? pop() {
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
