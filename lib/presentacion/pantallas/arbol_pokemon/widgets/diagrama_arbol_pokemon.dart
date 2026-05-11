import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/arbol_pokemon.dart';
import 'package:proyecto_final_progra3/nucleo/utilidades/imagen_pokemon_helper.dart';
import 'package:proyecto_final_progra3/presentacion/widgets/imagen_pokemon.dart';

class DiagramaArbolPokemon extends StatelessWidget {
  const DiagramaArbolPokemon({
    super.key,
    required this.raiz,
    required this.nombresRutaResaltada,
    required this.nombrePokemonEncontrado,
  });

  final NodoArbolPokemon raiz;
  final Set<String> nombresRutaResaltada;
  final String? nombrePokemonEncontrado;

  @override
  Widget build(BuildContext context) {
    final int profundidad = _obtenerProfundidad(raiz);
    final int maximaCantidadNodosNivel = _obtenerMaximoNodosPorNivel(raiz);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double anchoViewport = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.of(context).size.width - 32;
          final double altoViewport = 520;
          final double anchoLienzoEstimado =
              (maximaCantidadNodosNivel * 190).toDouble() + 140;
          final double altoLienzoEstimado =
              (profundidad * 168).toDouble() + 140;
          final double anchoLienzo = anchoLienzoEstimado < anchoViewport
              ? anchoViewport
              : anchoLienzoEstimado;
          final double altoLienzo = altoLienzoEstimado < altoViewport
              ? altoViewport
              : altoLienzoEstimado;

          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: altoViewport,
              width: double.infinity,
              child: InteractiveViewer(
                constrained: false,
                panEnabled: true,
                scaleEnabled: true,
                minScale: 0.70,
                maxScale: 1.9,
                boundaryMargin: const EdgeInsets.all(280),
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: anchoLienzo,
                  height: altoLienzo,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 44,
                        vertical: 22,
                      ),
                      child: _NodoDiagramaArbol(
                        nodo: raiz,
                        nivel: 0,
                        esRaiz: true,
                        nombresRutaResaltada: nombresRutaResaltada,
                        nombrePokemonEncontrado: nombrePokemonEncontrado,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  int _obtenerProfundidad(NodoArbolPokemon nodo) {
    if (nodo.hijos.isEmpty) {
      return 1;
    }
    int maxima = 0;
    for (final NodoArbolPokemon hijo in nodo.hijos) {
      final int profundidadHijo = _obtenerProfundidad(hijo);
      if (profundidadHijo > maxima) {
        maxima = profundidadHijo;
      }
    }
    return maxima + 1;
  }

  int _obtenerMaximoNodosPorNivel(NodoArbolPokemon raiz) {
    List<NodoArbolPokemon> nivelActual = <NodoArbolPokemon>[raiz];
    int maximo = 1;
    while (nivelActual.isNotEmpty) {
      if (nivelActual.length > maximo) {
        maximo = nivelActual.length;
      }
      final List<NodoArbolPokemon> siguienteNivel = <NodoArbolPokemon>[];
      for (final NodoArbolPokemon nodo in nivelActual) {
        siguienteNivel.addAll(nodo.hijos);
      }
      nivelActual = siguienteNivel;
    }
    return maximo;
  }
}

class _NodoDiagramaArbol extends StatelessWidget {
  const _NodoDiagramaArbol({
    required this.nodo,
    required this.nivel,
    required this.esRaiz,
    required this.nombresRutaResaltada,
    required this.nombrePokemonEncontrado,
  });

  final NodoArbolPokemon nodo;
  final int nivel;
  final bool esRaiz;
  final Set<String> nombresRutaResaltada;
  final String? nombrePokemonEncontrado;

  @override
  Widget build(BuildContext context) {
    final String nombreNormalizado = nodo.pokemon.nombre.toLowerCase();
    final bool esRutaResaltada = nombresRutaResaltada.contains(
      nombreNormalizado,
    );
    final bool esNodoEncontrado = nombrePokemonEncontrado == nombreNormalizado;
    final ReferenciasImagenPokemon? referenciasImagen =
        ImagenPokemonHelper.obtenerReferenciasDesdeUrl(nodo.pokemon.url);
    final List<NodoArbolPokemon> hijos = nodo.hijos;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TarjetaNodoDiagrama(
          nodo: nodo,
          nivel: nivel,
          esRaiz: esRaiz,
          imagenUrl: referenciasImagen?.urlPrincipal,
          imagenFallbackUrl: referenciasImagen?.urlFallback,
          esRutaResaltada: esRutaResaltada,
          esPokemonEncontrado: esNodoEncontrado,
        ),
        if (hijos.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(width: 2, height: 16, color: Colors.black26),
          if (hijos.length > 1)
            Container(
              width: (hijos.length * 178).toDouble(),
              height: 2,
              color: Colors.black26,
            ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: hijos.map((NodoArbolPokemon hijo) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 2, height: 14, color: Colors.black26),
                    const SizedBox(height: 6),
                    _NodoDiagramaArbol(
                      nodo: hijo,
                      nivel: nivel + 1,
                      esRaiz: false,
                      nombresRutaResaltada: nombresRutaResaltada,
                      nombrePokemonEncontrado: nombrePokemonEncontrado,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class _TarjetaNodoDiagrama extends StatelessWidget {
  const _TarjetaNodoDiagrama({
    required this.nodo,
    required this.nivel,
    required this.esRaiz,
    required this.imagenUrl,
    required this.imagenFallbackUrl,
    required this.esRutaResaltada,
    required this.esPokemonEncontrado,
  });

  final NodoArbolPokemon nodo;
  final int nivel;
  final bool esRaiz;
  final String? imagenUrl;
  final String? imagenFallbackUrl;
  final bool esRutaResaltada;
  final bool esPokemonEncontrado;

  @override
  Widget build(BuildContext context) {
    final bool esFinal = nodo.hijos.isEmpty;
    final Color colorBase = nodo.esTemporal
        ? Colors.orange.shade700
        : Colors.blue.shade700;

    Color colorFondo = colorBase.withValues(alpha: 0.09);
    Color colorBorde = colorBase.withValues(alpha: 0.25);
    double grosorBorde = 1;
    List<BoxShadow>? sombras;

    if (esRutaResaltada) {
      colorFondo = Colors.amber.withValues(alpha: 0.18);
      colorBorde = Colors.amber.shade700.withValues(alpha: 0.58);
      grosorBorde = 1.5;
    }
    if (esPokemonEncontrado) {
      colorFondo = Colors.green.withValues(alpha: 0.16);
      colorBorde = Colors.green.shade700;
      grosorBorde = 2.1;
      sombras = <BoxShadow>[
        BoxShadow(
          color: Colors.green.withValues(alpha: 0.22),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
    }

    return Container(
      width: 158,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorBorde, width: grosorBorde),
        boxShadow: sombras,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImagenPokemon(
                imagenUrl: imagenUrl,
                imagenFallbackUrl: imagenFallbackUrl,
                tamano: 30,
                radioBorde: 8,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatearNombrePokemon(nodo.pokemon.nombre),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Nivel ${nivel + 1}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Wrap(
            spacing: 5,
            runSpacing: 4,
            children: [
              if (esRaiz)
                const _BadgeNodoDiagrama(
                  texto: 'RAÍZ',
                  color: Color(0xFF4A3AB7),
                ),
              if (esRutaResaltada && !esPokemonEncontrado)
                const _BadgeNodoDiagrama(
                  texto: 'RUTA',
                  color: Color(0xFF996400),
                ),
              if (esPokemonEncontrado)
                const _BadgeNodoDiagrama(
                  texto: 'ENCONTRADO',
                  color: Color(0xFF1A7F44),
                ),
              if (nodo.esTemporal)
                const _BadgeNodoDiagrama(
                  texto: 'LOCAL',
                  color: Color(0xFFB26A00),
                ),
              if (esFinal)
                const _BadgeNodoDiagrama(
                  texto: 'FINAL',
                  color: Color(0xFF157A3F),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatearNombrePokemon(String nombre) {
    if (nombre.isEmpty) {
      return nombre;
    }
    return '${nombre[0].toUpperCase()}${nombre.substring(1)}';
  }
}

class _BadgeNodoDiagrama extends StatelessWidget {
  const _BadgeNodoDiagrama({required this.texto, required this.color});

  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.34)),
      ),
      child: Text(
        texto,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
