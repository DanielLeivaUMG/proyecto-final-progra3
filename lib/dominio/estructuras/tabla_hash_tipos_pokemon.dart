import 'package:proyecto_final_progra3/dominio/entidades/relaciones_danio_tipo.dart';

class TablaHashTiposPokemon {
  final Map<String, RelacionesDanioTipo> _tabla =
      <String, RelacionesDanioTipo>{};

  void insertarTipo(RelacionesDanioTipo relaciones) {
    final String tipoNormalizado = _normalizar(relaciones.tipo);
    if (tipoNormalizado.isEmpty) {
      return;
    }

    _tabla[tipoNormalizado] = relaciones;
  }

  RelacionesDanioTipo? buscarTipo(String tipo) {
    return _tabla[_normalizar(tipo)];
  }

  void eliminarTipo(String tipo) {
    _tabla.remove(_normalizar(tipo));
  }

  bool contieneTipo(String tipo) {
    return _tabla.containsKey(_normalizar(tipo));
  }

  int get cantidad => _tabla.length;

  bool get estaVacia => _tabla.isEmpty;

  List<String> obtenerClaves() {
    return _tabla.keys.toList();
  }

  List<RelacionesDanioTipo> obtenerTodos() {
    return _tabla.values.toList();
  }

  void limpiar() {
    _tabla.clear();
  }

  double obtenerMultiplicadorDefensivo({
    required List<String> tiposDefensores,
    required String tipoAtacante,
  }) {
    final String tipoAtacanteNormalizado = _normalizar(tipoAtacante);
    if (tipoAtacanteNormalizado.isEmpty || tiposDefensores.isEmpty) {
      return 1;
    }

    double multiplicador = 1;

    for (final String tipoDefensor in tiposDefensores) {
      final RelacionesDanioTipo? relaciones = buscarTipo(tipoDefensor);
      if (relaciones == null) {
        continue;
      }

      multiplicador *= _obtenerFactorDefensivo(
        relaciones: relaciones,
        tipoAtacante: tipoAtacanteNormalizado,
      );
    }

    return multiplicador;
  }

  double _obtenerFactorDefensivo({
    required RelacionesDanioTipo relaciones,
    required String tipoAtacante,
  }) {
    final Set<String> sinDanio = relaciones.sinDanioDe
        .map(_normalizar)
        .where((String tipo) => tipo.isNotEmpty)
        .toSet();
    final Set<String> medioDanio = relaciones.medioDanioDe
        .map(_normalizar)
        .where((String tipo) => tipo.isNotEmpty)
        .toSet();
    final Set<String> dobleDanio = relaciones.dobleDanioDe
        .map(_normalizar)
        .where((String tipo) => tipo.isNotEmpty)
        .toSet();

    if (sinDanio.contains(tipoAtacante)) {
      return 0;
    }

    if (medioDanio.contains(tipoAtacante)) {
      return 0.5;
    }

    if (dobleDanio.contains(tipoAtacante)) {
      return 2;
    }

    return 1;
  }

  String _normalizar(String valor) {
    return valor.trim().toLowerCase();
  }
}
