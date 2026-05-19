import 'package:proyecto_final_progra3/dominio/entidades/pokemon_carta.dart';

// Cola de Pokémon (FIFO)
class ColaPokemon {
  final List<PokemonCarta> _cola = [];

  List<PokemonCarta> get elementos => List.unmodifiable(_cola);

  bool get estaVacia => _cola.isEmpty;

  PokemonCarta? get frente => estaVacia ? null : _cola.first;

  void enqueue(PokemonCarta pokemon) {
    _cola.add(pokemon);
  }

  PokemonCarta? dequeue() {
    if (estaVacia) return null;
    return _cola.removeAt(0);
  }

  // El primero ataca y luego pasa al final
  PokemonCarta? atacarYRotar() {
    if (estaVacia) return null;

    final PokemonCarta atacante = _cola.removeAt(0);
    _cola.add(atacante);

    return atacante;
  }

  int buscarPosicion(String nombre) {
    for (int i = 0; i < _cola.length; i++) {
      if (_cola[i].nombre.toLowerCase() == nombre.toLowerCase()) {
        return i + 1;
      }
    }
    return -1;
  }

  void limpiar() {
    _cola.clear();
  }
}
