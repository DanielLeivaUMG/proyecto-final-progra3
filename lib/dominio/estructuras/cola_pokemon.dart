import '../../datos/modelos/modelo_pokemon.dart';

// Cola de Pokémon (FIFO)
class ColaPokemon {
  final List<Pokemon> _cola = [];

  List<Pokemon> get elementos => List.unmodifiable(_cola);

  bool get estaVacia => _cola.isEmpty;

  Pokemon? get frente => estaVacia ? null : _cola.first;

  // Enqueue: agregar al final
  void enqueue(Pokemon pokemon) {
    _cola.add(pokemon);
  }

  // Dequeue: quitar el primero (ataca)
  Pokemon? dequeue() {
    if (estaVacia) return null;
    return _cola.removeAt(0);
  }

  // Buscar posición en la fila
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
