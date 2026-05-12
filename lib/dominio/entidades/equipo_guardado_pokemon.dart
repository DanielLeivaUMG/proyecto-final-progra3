import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';

class EquipoGuardadoPokemon {
  static const int cantidadIntegrantesRequerida = 6;

  EquipoGuardadoPokemon({
    required this.id,
    required this.nombre,
    required this.fechaGuardado,
    required List<Pokemon> pokemones,
  }) : _pokemones = List<Pokemon>.from(pokemones);

  final String id;
  final String nombre;
  final DateTime fechaGuardado;
  final List<Pokemon> _pokemones;

  List<Pokemon> get pokemones {
    return List<Pokemon>.from(_pokemones);
  }

  bool get esValido {
    return _pokemones.length == cantidadIntegrantesRequerida;
  }
}
