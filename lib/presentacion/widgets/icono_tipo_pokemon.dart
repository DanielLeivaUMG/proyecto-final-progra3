import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/nucleo/utilidades/icono_tipo_pokemon_helper.dart';

class IconoTipoPokemon extends StatelessWidget {
  const IconoTipoPokemon({
    super.key,
    required this.idTipo,
    this.tamano = 20,
    this.ancho,
    this.alto,
    this.radioBorde = 4,
  });

  final int? idTipo;
  final double tamano;
  final double? ancho;
  final double? alto;
  final double radioBorde;

  @override
  Widget build(BuildContext context) {
    final String? url = IconoTipoPokemonHelper.obtenerUrlPorIdTipo(idTipo);
    final double anchoFinal = ancho ?? tamano;
    final double altoFinal = alto ?? tamano;

    if (url == null) {
      return _construirFallback(anchoFinal, altoFinal);
    }

    return SizedBox(
      width: anchoFinal,
      height: altoFinal,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radioBorde),
        child: Image.network(
          url,
          fit: BoxFit.contain,
          loadingBuilder:
              (
                BuildContext context,
                Widget child,
                ImageChunkEvent? loadingProgress,
              ) {
                if (loadingProgress == null) {
                  return child;
                }
                return _construirFallback(
                  anchoFinal,
                  altoFinal,
                  cargando: true,
                );
              },
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
                return _construirFallback(anchoFinal, altoFinal);
              },
        ),
      ),
    );
  }

  Widget _construirFallback(
    double anchoFinal,
    double altoFinal, {
    bool cargando = false,
  }) {
    final double ladoReferencia = anchoFinal < altoFinal
        ? anchoFinal
        : altoFinal;

    return Container(
      width: anchoFinal,
      height: altoFinal,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(radioBorde),
      ),
      child: cargando
          ? SizedBox(
              width: ladoReferencia * 0.5,
              height: ladoReferencia * 0.5,
              child: const CircularProgressIndicator(strokeWidth: 1.8),
            )
          : Icon(
              Icons.category_outlined,
              size: ladoReferencia * 0.72,
              color: Colors.grey.shade700,
            ),
    );
  }
}
