import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';

class ModeloPokemon {
  final String nombre;
  final String url;

  const ModeloPokemon({required this.nombre, required this.url});

  factory ModeloPokemon.fromJson(Map<String, dynamic> json) {
    return ModeloPokemon(
      nombre: (json['name'] as String? ?? '').toLowerCase(),
      url: (json['url'] as String? ?? '').trim(),
    );
  }

  Pokemon aEntidad() {
    return Pokemon(nombre: nombre, url: url, id: _extraerIdDesdeUrl(url));
  }

  static int? _extraerIdDesdeUrl(String url) {
    final RegExp patron = RegExp(r'/pokemon/(\d+)/?$', caseSensitive: false);
    final RegExpMatch? coincidencia = patron.firstMatch(url.trim());
    if (coincidencia == null) {
      return null;
    }

    return int.tryParse(coincidencia.group(1) ?? '');
  }
}
