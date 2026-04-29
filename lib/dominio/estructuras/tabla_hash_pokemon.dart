import 'package:proyecto_final_progra3/datos/modelos/modelo_pokemon.dart';

class TablaHashPokemon {
  final Map<String, Pokemon> _tabla = <String, Pokemon>{};

  void insertar(Pokemon pokemon) {
    _tabla[pokemon.nombre.toLowerCase()] = pokemon;
  }

  Pokemon? buscarPorNombre(String nombre) {
    return _tabla[nombre.toLowerCase()];
  }

  void eliminar(String nombre) {
    _tabla.remove(nombre.toLowerCase());
  }

  bool contiene(String nombre) {
    return _tabla.containsKey(nombre.toLowerCase());
  }

  int cantidad() {
    return _tabla.length;
  }

  List<Pokemon> obtenerTodos() {
    return _tabla.values.toList();
  }

  List<String> obtenerClaves() {
    return _tabla.keys.toList();
  }
}
