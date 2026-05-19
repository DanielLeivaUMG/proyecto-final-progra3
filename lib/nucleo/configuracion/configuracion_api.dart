class ConfiguracionApi {
  const ConfiguracionApi._();

  static const String urlBase = String.fromEnvironment('API_URL_BASE');
  static const String urlBaseSprites = String.fromEnvironment(
    'POKEAPI_SPRITES_URL_BASE',
  );
  static const String urlBaseIconosTipos = String.fromEnvironment(
    'POKEAPI_TYPE_ICONS_URL_BASE',
  );

  static void validar() {
    if (urlBase.trim().isEmpty) {
      throw StateError(
        'Falta configurar API_URL_BASE. Ejecuta la app con '
        '--dart-define-from-file=.env',
      );
    }

    if (urlBaseSprites.trim().isEmpty) {
      throw StateError(
        'Falta configurar POKEAPI_SPRITES_URL_BASE. Ejecuta la app con '
        '--dart-define-from-file=.env',
      );
    }

    if (urlBaseIconosTipos.trim().isEmpty) {
      throw StateError(
        'Falta configurar POKEAPI_TYPE_ICONS_URL_BASE. Ejecuta la app con '
        '--dart-define-from-file=.env',
      );
    }
  }
}
