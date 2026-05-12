import 'package:proyecto_final_progra3/dominio/entidades/equipo_guardado_pokemon.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';

class EquiposRecientesPokemon {
  EquiposRecientesPokemon({this.maximoRecientes = 10})
    : assert(maximoRecientes > 0, 'maximoRecientes debe ser mayor que 0');

  final int maximoRecientes;
  final List<EquipoGuardadoPokemon> _recientes = <EquipoGuardadoPokemon>[];

  int _contadorSecuencial = 0;
  int _contadorNombres = 0;

  EquipoGuardadoPokemon? guardarEquipo(List<Pokemon> pokemones) {
    final List<Pokemon> snapshot = List<Pokemon>.from(pokemones);

    if (!_esEquipoCompleto(snapshot)) {
      return null;
    }

    if (_recientes.any(
      (EquipoGuardadoPokemon existente) =>
          _sonEquiposExactamenteIguales(existente.pokemones, snapshot),
    )) {
      return null;
    }

    final DateTime ahora = DateTime.now();
    _contadorSecuencial++;
    _contadorNombres++;

    final EquipoGuardadoPokemon nuevo = EquipoGuardadoPokemon(
      id: _generarIdSesion(ahora),
      nombre: 'Equipo $_contadorNombres',
      fechaGuardado: ahora,
      pokemones: snapshot,
    );

    _recientes.insert(0, nuevo);
    _recortarSiExcedeLimite();
    return nuevo;
  }

  bool eliminarPorId(String id) {
    final int indice = _recientes.indexWhere(
      (EquipoGuardadoPokemon equipo) => equipo.id == id,
    );
    if (indice < 0) {
      return false;
    }

    _recientes.removeAt(indice);
    return true;
  }

  EquipoGuardadoPokemon? buscarPorId(String id) {
    for (final EquipoGuardadoPokemon equipo in _recientes) {
      if (equipo.id == id) {
        return equipo;
      }
    }
    return null;
  }

  List<EquipoGuardadoPokemon> obtenerTodos() {
    return List<EquipoGuardadoPokemon>.from(_recientes);
  }

  void limpiar() {
    _recientes.clear();
  }

  int get cantidad => _recientes.length;

  bool get estaVacio => _recientes.isEmpty;

  bool _esEquipoCompleto(List<Pokemon> pokemones) {
    return pokemones.length ==
        EquipoGuardadoPokemon.cantidadIntegrantesRequerida;
  }

  bool _sonEquiposExactamenteIguales(List<Pokemon> a, List<Pokemon> b) {
    if (a.length != b.length) {
      return false;
    }

    for (int i = 0; i < a.length; i++) {
      if (!_sonMismoPokemon(a[i], b[i])) {
        return false;
      }
    }

    return true;
  }

  bool _sonMismoPokemon(Pokemon primero, Pokemon segundo) {
    if (primero.id != null || segundo.id != null) {
      if (primero.id == null || segundo.id == null) {
        return false;
      }
      return primero.id == segundo.id;
    }

    return _normalizar(primero.nombre) == _normalizar(segundo.nombre);
  }

  String _normalizar(String valor) {
    return valor.trim().toLowerCase();
  }

  String _generarIdSesion(DateTime fecha) {
    return 'eq-${fecha.microsecondsSinceEpoch}-$_contadorSecuencial';
  }

  void _recortarSiExcedeLimite() {
    while (_recientes.length > maximoRecientes) {
      _recientes.removeLast();
    }
  }
}
