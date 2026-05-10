import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';

class ModeloPokemon {
  final String nombre;
  final String url;

  const ModeloPokemon({required this.nombre, required this.url});

  factory ModeloPokemon.fromJson(Map<String, dynamic> json) {
    return ModeloPokemon(nombre: json['name'] ?? '', url: json['url'] ?? '');
  }

  Pokemon aEntidad() {
    return Pokemon(nombre: nombre, url: url);
  }
}
