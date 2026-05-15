import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart'
    as entidad;

// Modelo básico de Pokémon para pila y cola visual
class Pokemon {
  final int id;
  final String nombre;
  final String tipo;
  final String imagenUrl;

  final int hp;
  final int ataque;
  final int defensa;
  final int velocidad;

  const Pokemon({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.imagenUrl,
    required this.hp,
    required this.ataque,
    required this.defensa,
    required this.velocidad,
  });

  int get poderTotal => hp + ataque + defensa + velocidad;

  Pokemon copyWith({
    int? id,
    String? nombre,
    String? tipo,
    String? imagenUrl,
    int? hp,
    int? ataque,
    int? defensa,
    int? velocidad,
  }) {
    return Pokemon(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      hp: hp ?? this.hp,
      ataque: ataque ?? this.ataque,
      defensa: defensa ?? this.defensa,
      velocidad: velocidad ?? this.velocidad,
    );
  }
}

// Modelo usado por el servicio de la PokeAPI
class ModeloPokemon {
  final String nombre;
  final String url;

  const ModeloPokemon({required this.nombre, required this.url});

  factory ModeloPokemon.fromJson(Map<String, dynamic> json) {
    return ModeloPokemon(
      nombre: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  entidad.Pokemon aEntidad() {
    return entidad.Pokemon(nombre: nombre, url: url);
  }
}
