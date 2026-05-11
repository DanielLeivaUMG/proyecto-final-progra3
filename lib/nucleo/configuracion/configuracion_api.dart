class ConfiguracionApi {
  const ConfiguracionApi._();

  static const String urlBase = String.fromEnvironment('API_URL_BASE');
  static const String urlBaseSprites = String.fromEnvironment(
    'POKEAPI_SPRITES_URL_BASE',
  );

  static void validar() {
    if (urlBase.trim().isEmpty) {
      throw StateError(
        'Falta configurar API_URL_BASE. Ejecuta la app con '
        '--dart-define-from-file=entornos/dev.json',
      );
    }

    if (urlBaseSprites.trim().isEmpty) {
      throw StateError(
        'Falta configurar POKEAPI_SPRITES_URL_BASE. Ejecuta la app con '
        '--dart-define-from-file=entornos/dev.json',
      );
    }
  }
}
