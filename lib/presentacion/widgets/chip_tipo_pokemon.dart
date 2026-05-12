import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/presentacion/widgets/icono_tipo_pokemon.dart';

class ChipTipoPokemon extends StatelessWidget {
  const ChipTipoPokemon({
    super.key,
    required this.nombre,
    this.idTipo,
    this.compacto = false,
    this.modoBadge = false,
    this.anchoBadge,
    this.altoBadge,
  });

  final int? idTipo;
  final String nombre;
  final bool compacto;
  final bool modoBadge;
  final double? anchoBadge;
  final double? altoBadge;

  @override
  Widget build(BuildContext context) {
    final bool tieneIcono = idTipo != null && idTipo! > 0;
    final double anchoBadgeFinal = anchoBadge ?? (compacto ? 72 : 84);
    final double altoBadgeFinal = altoBadge ?? (compacto ? 24 : 28);
    final double anchoMaximoHorizontal = compacto ? 126 : 164;
    final String etiqueta = nombre.trim().isEmpty ? 'tipo' : nombre.trim();

    if (modoBadge) {
      if (compacto) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: anchoBadgeFinal + 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (tieneIcono)
                  IconoTipoPokemon(
                    idTipo: idTipo,
                    ancho: anchoBadgeFinal,
                    alto: altoBadgeFinal,
                    radioBorde: 5,
                  ),
                const SizedBox(height: 3),
                SizedBox(
                  width: anchoBadgeFinal,
                  child: Text(
                    etiqueta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: anchoMaximoHorizontal),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (tieneIcono) ...[
                IconoTipoPokemon(
                  idTipo: idTipo,
                  ancho: anchoBadgeFinal,
                  alto: altoBadgeFinal,
                  radioBorde: 5,
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  etiqueta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: anchoMaximoHorizontal),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compacto ? 8 : 10,
          vertical: compacto ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: Colors.blueGrey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (tieneIcono) ...[
              IconoTipoPokemon(
                idTipo: idTipo,
                tamano: compacto ? 14 : 18,
                radioBorde: 3,
              ),
              SizedBox(width: compacto ? 5 : 6),
            ],
            Flexible(
              child: Text(
                etiqueta,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: compacto ? 11.5 : 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
