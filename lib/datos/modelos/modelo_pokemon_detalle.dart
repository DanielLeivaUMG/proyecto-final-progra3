import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';

class ModeloPokemonDetalle {
  const ModeloPokemonDetalle({
    required this.id,
    required this.nombre,
    required this.url,
    required this.tipos,
  });

  final int id;
  final String nombre;
  final String url;
  final List<String> tipos;

  factory ModeloPokemonDetalle.fromJson(
    Map<String, dynamic> json, {
    required String urlBasePokemon,
  }) {
    final int id = (json['id'] as num?)?.toInt() ?? 0;
    final String nombre = (json['name'] as String? ?? '').toLowerCase();
    final List<String> tipos = _extraerTipos(json['types']);
    final String url = id > 0
        ? '$urlBasePokemon/$id'
        : '$urlBasePokemon/$nombre';

    return ModeloPokemonDetalle(id: id, nombre: nombre, url: url, tipos: tipos);
  }

  Pokemon aEntidad() {
    return Pokemon(nombre: nombre, url: url, id: id, tipos: tipos);
  }

  static List<String> _extraerTipos(dynamic tiposJson) {
    if (tiposJson is! List<dynamic>) {
      return <String>[];
    }

    final List<Map<String, dynamic>> entradasOrdenadas =
        tiposJson.whereType<Map<String, dynamic>>().toList()..sort((a, b) {
          final int ordenA = (a['slot'] as num?)?.toInt() ?? 999;
          final int ordenB = (b['slot'] as num?)?.toInt() ?? 999;
          return ordenA.compareTo(ordenB);
        });

    return entradasOrdenadas
        .map((Map<String, dynamic> item) {
          final Map<String, dynamic> tipo =
              item['type'] as Map<String, dynamic>? ?? <String, dynamic>{};
          return (tipo['name'] as String? ?? '').toLowerCase();
        })
        .where((String tipo) => tipo.isNotEmpty)
        .toList();
  }
}
