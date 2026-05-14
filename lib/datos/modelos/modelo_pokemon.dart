import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart'
    as entidad;

// Modelo básico de Pokémon para pila y cola
class Pokemon {
  final int id;
  final String nombre;
  final String tipo;
  final String imagenUrl;

  const Pokemon({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.imagenUrl,
  });

  // Para crear copias modificando algún dato
  Pokemon copyWith({int? id, String? nombre, String? tipo, String? imagenUrl}) {
    return Pokemon(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      imagenUrl: imagenUrl ?? this.imagenUrl,
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
