import 'package:proyecto_final_progra3/dominio/entidades/relaciones_danio_tipo.dart';
import 'package:proyecto_final_progra3/nucleo/configuracion/configuracion_api.dart';

class IconoTipoPokemonHelper {
  IconoTipoPokemonHelper._();

  static String? obtenerUrlPorIdTipo(int? idTipo) {
    if (idTipo == null || idTipo <= 0) {
      return null;
    }

    final String base = ConfiguracionApi.urlBaseIconosTipos.trim();
    if (base.isEmpty) {
      return null;
    }

    final String baseNormalizada = base.endsWith('/')
        ? base.substring(0, base.length - 1)
        : base;
    return '$baseNormalizada/$idTipo.png';
  }

  static String? obtenerUrlDesdeRelaciones(RelacionesDanioTipo? relaciones) {
    return obtenerUrlPorIdTipo(relaciones?.idTipo);
  }
}
