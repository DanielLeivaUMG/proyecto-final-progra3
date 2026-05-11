import 'package:proyecto_final_progra3/nucleo/configuracion/configuracion_api.dart';

class ReferenciasImagenPokemon {
  const ReferenciasImagenPokemon({
    required this.urlPrincipal,
    required this.urlFallback,
  });

  final String urlPrincipal;
  final String urlFallback;
}

class ImagenPokemonHelper {
  ImagenPokemonHelper._();

  static ReferenciasImagenPokemon? obtenerReferenciasDesdeUrl(
    String? urlPokemonOEspecie,
  ) {
    final int? idPokemon = _extraerIdPokemon(urlPokemonOEspecie);
    if (idPokemon == null) {
      return null;
    }

    final String baseSprites = ConfiguracionApi.urlBaseSprites;
    return ReferenciasImagenPokemon(
      urlPrincipal: '$baseSprites/other/official-artwork/$idPokemon.png',
      urlFallback: '$baseSprites/$idPokemon.png',
    );
  }

  static String? obtenerUrlImagenPrincipal(String? urlPokemonOEspecie) {
    return obtenerReferenciasDesdeUrl(urlPokemonOEspecie)?.urlPrincipal;
  }

  static String? obtenerUrlImagenFallback(String? urlPokemonOEspecie) {
    return obtenerReferenciasDesdeUrl(urlPokemonOEspecie)?.urlFallback;
  }

  static int? _extraerIdPokemon(String? urlPokemonOEspecie) {
    if (urlPokemonOEspecie == null) {
      return null;
    }

    final String valor = urlPokemonOEspecie.trim();
    if (valor.isEmpty || valor.startsWith('local://')) {
      return null;
    }

    final RegExp patron = RegExp(
      r'/(pokemon|pokemon-species)/(\d+)/?$',
      caseSensitive: false,
    );
    final RegExpMatch? coincidencia = patron.firstMatch(valor);
    if (coincidencia != null) {
      return int.tryParse(coincidencia.group(2)!);
    }

    final Uri? uri = Uri.tryParse(valor);
    if (uri == null) {
      return null;
    }

    final List<String> segmentos = uri.pathSegments
        .where((String segmento) => segmento.isNotEmpty)
        .toList();
    for (int indice = 0; indice < segmentos.length - 1; indice++) {
      final String actual = segmentos[indice].toLowerCase();
      if (actual == 'pokemon' || actual == 'pokemon-species') {
        return int.tryParse(segmentos[indice + 1]);
      }
    }

    return null;
  }
}
