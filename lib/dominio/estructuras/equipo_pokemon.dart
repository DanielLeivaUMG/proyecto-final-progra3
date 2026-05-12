import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';

class EquipoPokemon {
  static const int _maximoIntegrantes = 6;

  final List<Pokemon> _equipo = <Pokemon>[];

  bool agregarPokemon(Pokemon pokemon) {
    if (estaLleno || _esInvalido(pokemon)) {
      return false;
    }

    if (_esDuplicado(pokemon)) {
      return false;
    }

    _equipo.add(pokemon);
    return true;
  }

  bool eliminarPorNombre(String nombre) {
    final String nombreNormalizado = _normalizar(nombre);
    if (nombreNormalizado.isEmpty) {
      return false;
    }

    final int indice = _equipo.indexWhere(
      (Pokemon pokemon) => _normalizar(pokemon.nombre) == nombreNormalizado,
    );
    if (indice < 0) {
      return false;
    }

    _equipo.removeAt(indice);
    return true;
  }

  bool eliminarPorId(int id) {
    final int indice = _equipo.indexWhere(
      (Pokemon pokemon) => pokemon.id == id,
    );
    if (indice < 0) {
      return false;
    }

    _equipo.removeAt(indice);
    return true;
  }

  Pokemon? buscarPorNombre(String nombre) {
    final String nombreNormalizado = _normalizar(nombre);
    if (nombreNormalizado.isEmpty) {
      return null;
    }

    for (final Pokemon pokemon in _equipo) {
      if (_normalizar(pokemon.nombre) == nombreNormalizado) {
        return pokemon;
      }
    }
    return null;
  }

  Pokemon? buscarPorId(int id) {
    for (final Pokemon pokemon in _equipo) {
      if (pokemon.id == id) {
        return pokemon;
      }
    }
    return null;
  }

  List<Pokemon> obtenerEquipo() {
    return List<Pokemon>.from(_equipo);
  }

  int get cantidad => _equipo.length;

  bool get estaVacio => _equipo.isEmpty;

  bool get estaLleno => _equipo.length >= _maximoIntegrantes;

  void limpiar() {
    _equipo.clear();
  }

  bool _esInvalido(Pokemon pokemon) {
    return _normalizar(pokemon.nombre).isEmpty;
  }

  bool _esDuplicado(Pokemon pokemon) {
    if (pokemon.id != null) {
      return _equipo.any((Pokemon actual) => actual.id == pokemon.id);
    }

    final String nombreNormalizado = _normalizar(pokemon.nombre);
    return _equipo.any(
      (Pokemon actual) => _normalizar(actual.nombre) == nombreNormalizado,
    );
  }

  String _normalizar(String valor) {
    return valor.trim().toLowerCase();
  }
}
