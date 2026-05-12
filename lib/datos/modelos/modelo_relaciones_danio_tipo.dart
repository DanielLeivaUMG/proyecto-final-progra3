import 'package:proyecto_final_progra3/dominio/entidades/relaciones_danio_tipo.dart';

class ModeloRelacionesDanioTipo {
  const ModeloRelacionesDanioTipo({
    this.idTipo,
    required this.tipo,
    required this.nombreMostrado,
    required this.sinDanioDe,
    required this.medioDanioDe,
    required this.dobleDanioDe,
  });

  final int? idTipo;
  final String tipo;
  final String nombreMostrado;
  final List<String> sinDanioDe;
  final List<String> medioDanioDe;
  final List<String> dobleDanioDe;

  factory ModeloRelacionesDanioTipo.fromJson(Map<String, dynamic> json) {
    final int? idTipo = json['id'] is int ? json['id'] as int : null;
    final String tipo = (json['name'] as String? ?? '').toLowerCase();
    final String nombreMostrado = _extraerNombreEspanol(json['names'], tipo);
    final Map<String, dynamic> relaciones =
        json['damage_relations'] as Map<String, dynamic>? ??
        <String, dynamic>{};

    return ModeloRelacionesDanioTipo(
      idTipo: idTipo,
      tipo: tipo,
      nombreMostrado: nombreMostrado,
      sinDanioDe: _extraerNombres(relaciones['no_damage_from']),
      medioDanioDe: _extraerNombres(relaciones['half_damage_from']),
      dobleDanioDe: _extraerNombres(relaciones['double_damage_from']),
    );
  }

  RelacionesDanioTipo aEntidad() {
    return RelacionesDanioTipo(
      idTipo: idTipo,
      tipo: tipo,
      nombreMostrado: nombreMostrado,
      sinDanioDe: sinDanioDe,
      medioDanioDe: medioDanioDe,
      dobleDanioDe: dobleDanioDe,
    );
  }

  static List<String> _extraerNombres(dynamic tiposJson) {
    if (tiposJson is! List<dynamic>) {
      return <String>[];
    }

    return tiposJson
        .whereType<Map<String, dynamic>>()
        .map(
          (Map<String, dynamic> item) =>
              (item['name'] as String? ?? '').toLowerCase(),
        )
        .where((String tipo) => tipo.isNotEmpty)
        .toList();
  }

  static String _extraerNombreEspanol(
    dynamic nombresJson,
    String tipoFallback,
  ) {
    if (nombresJson is! List<dynamic>) {
      return tipoFallback;
    }

    for (final dynamic item in nombresJson) {
      if (item is! Map<String, dynamic>) {
        continue;
      }

      final Map<String, dynamic> language =
          item['language'] as Map<String, dynamic>? ?? <String, dynamic>{};
      final String codigoIdioma = (language['name'] as String? ?? '')
          .trim()
          .toLowerCase();
      if (codigoIdioma == 'es') {
        final String nombre = (item['name'] as String? ?? '').trim();
        if (nombre.isNotEmpty) {
          return nombre;
        }
      }
    }

    return tipoFallback;
  }
}
