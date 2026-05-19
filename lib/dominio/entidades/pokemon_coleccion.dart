import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';

enum EstadoColeccionPokemon {
  capturado,
  pendiente,
  deseado,
  intercambiable,
}

class PokemonColeccion {
  const PokemonColeccion({
    required this.pokemon,
    required this.estado,
    required this.esShiny,
    required this.fechaRegistro,
  });

  final Pokemon pokemon;
  final EstadoColeccionPokemon estado;
  final bool esShiny;
  final DateTime fechaRegistro;

  PokemonColeccion copiarCon({
    Pokemon? pokemon,
    EstadoColeccionPokemon? estado,
    bool? esShiny,
    DateTime? fechaRegistro,
  }) {
    return PokemonColeccion(
      pokemon: pokemon ?? this.pokemon,
      estado: estado ?? this.estado,
      esShiny: esShiny ?? this.esShiny,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
    );
  }
}
