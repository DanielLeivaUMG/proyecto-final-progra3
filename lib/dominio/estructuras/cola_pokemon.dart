import '../../datos/modelos/modelo_pokemon.dart';

// Cola de Pokémon (FIFO)
class ColaPokemon {
  final List<Pokemon> _cola = [];

  List<Pokemon> get elementos => List.unmodifiable(_cola);

  bool get estaVacia => _cola.isEmpty;

  Pokemon? get frente => estaVacia ? null : _cola.first;

  void enqueue(Pokemon pokemon) {
    _cola.add(pokemon);
  }

  Pokemon? dequeue() {
    if (estaVacia) return null;
    return _cola.removeAt(0);
  }

  // El primero ataca y luego pasa al final
  Pokemon? atacarYRotar() {
    if (estaVacia) return null;

    final Pokemon atacante = _cola.removeAt(0);
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
