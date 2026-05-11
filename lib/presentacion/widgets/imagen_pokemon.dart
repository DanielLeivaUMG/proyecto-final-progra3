import 'package:flutter/material.dart';

class ImagenPokemon extends StatelessWidget {
  const ImagenPokemon({
    super.key,
    required this.imagenUrl,
    required this.imagenFallbackUrl,
    this.tamano = 42,
    this.radioBorde = 10,
  });

  final String? imagenUrl;
  final String? imagenFallbackUrl;
  final double tamano;
  final double radioBorde;

  @override
  Widget build(BuildContext context) {
    if (imagenUrl == null || imagenUrl!.isEmpty) {
      return _construirPlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radioBorde),
      child: _construirImagenRed(url: imagenUrl!, permitirFallback: true),
    );
  }

  Widget _construirImagenRed({
    required String url,
    required bool permitirFallback,
  }) {
    return Image.network(
      url,
      width: tamano,
      height: tamano,
      fit: BoxFit.cover,
      loadingBuilder:
          (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) {
              return child;
            }
            return _construirPlaceholder(cargando: true);
          },
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
            if (permitirFallback &&
                imagenFallbackUrl != null &&
                imagenFallbackUrl!.isNotEmpty &&
                imagenFallbackUrl != url) {
              return _construirImagenRed(
                url: imagenFallbackUrl!,
                permitirFallback: false,
              );
            }
            return _construirPlaceholder();
          },
    );
  }

  Widget _construirPlaceholder({bool cargando = false}) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(radioBorde),
      ),
      alignment: Alignment.center,
      child: cargando
          ? SizedBox(
              width: tamano * 0.42,
              height: tamano * 0.42,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              Icons.catching_pokemon_rounded,
              size: tamano * 0.54,
              color: Colors.grey.shade600,
            ),
    );
  }
}
