import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/dominio/entidades/relaciones_danio_tipo.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/tabla_hash_tipos_pokemon.dart';
import 'package:proyecto_final_progra3/presentacion/widgets/chip_tipo_pokemon.dart';

class PestanaAnalisisHash extends StatelessWidget {
  const PestanaAnalisisHash({
    super.key,
    required this.equipo,
    required this.tablaHashTiposPokemon,
    required this.cargandoTipos,
  });

  final List<Pokemon> equipo;
  final TablaHashTiposPokemon tablaHashTiposPokemon;
  final bool cargandoTipos;

  static const List<String> _tiposBase = <String>[
    'normal',
    'fire',
    'water',
    'electric',
    'grass',
    'ice',
    'fighting',
    'poison',
    'ground',
    'flying',
    'psychic',
    'bug',
    'rock',
    'ghost',
    'dragon',
    'dark',
    'steel',
    'fairy',
  ];

  @override
  Widget build(BuildContext context) {
    if (equipo.isEmpty) {
      return const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Agrega Pokémon al equipo para analizar sus debilidades.',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ),
      );
    }

    final List<String> tiposAtacantes = _obtenerTiposAtacantes();
    final List<_FilaMatrizDefensiva> filas = tiposAtacantes
        .map(_calcularFilaDefensiva)
        .toList();

    final int vulnerabilidadesTotales = filas.fold<int>(
      0,
      (int acumulado, _FilaMatrizDefensiva fila) => acumulado + fila.debiles,
    );
    final _FilaMatrizDefensiva? tipoMasPeligroso = _obtenerTipoMasPeligroso(
      filas,
    );
    final List<_FilaMatrizDefensiva> top3Riesgos = _obtenerTop3Riesgos(filas);
    final String? tipoMasPeligrosoMostrado = tipoMasPeligroso == null
        ? null
        : _nombreTipoMostrado(tipoMasPeligroso.tipoAtacante);
    final String diagnostico = _generarDiagnostico(
      tipoMasPeligroso: tipoMasPeligroso,
      tipoMasPeligrosoMostrado: tipoMasPeligrosoMostrado,
    );
    final List<String> recomendacionesDefensivas = _generarRecomendaciones(
      top3Riesgos,
    );
    final bool hayAmenazaCritica = _hayAmenazaCritica(tipoMasPeligroso);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ResumenAnalisisBasico(
            cantidadPokemon: equipo.length,
            cantidadTiposCargados: tablaHashTiposPokemon.cantidad,
            tipoMasPeligroso: tipoMasPeligrosoMostrado,
            vulnerabilidadesTotales: vulnerabilidadesTotales,
          ),
          const SizedBox(height: 12),
          _TarjetaTopRiesgos(
            filasTopRiesgo: top3Riesgos,
            resolverNombreTipo: _nombreTipoMostrado,
            resolverIdTipo: _obtenerIdTipo,
          ),
          const SizedBox(height: 12),
          _TarjetaDiagnostico(texto: diagnostico),
          const SizedBox(height: 12),
          _TarjetaRecomendaciones(
            recomendaciones: recomendacionesDefensivas,
            hayAmenazaCritica: hayAmenazaCritica,
            resolverNombreTipo: _nombreTipoMostrado,
            resolverIdTipo: _obtenerIdTipo,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Matriz básica de impacto defensivo',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  if (cargandoTipos) ...[
                    const LinearProgressIndicator(),
                    const SizedBox(height: 8),
                    const Text(
                      'Cargando nombres localizados de tipos...',
                      style: TextStyle(fontSize: 12.5, color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                  ],
                  const Text(
                    'Desliza horizontalmente para ver todos los Pokémon del equipo.',
                    style: TextStyle(fontSize: 12.5, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 10,
                      dataRowMinHeight: 48,
                      dataRowMaxHeight: 58,
                      columns: [
                        const DataColumn(label: Text('Tipo atacante')),
                        ...equipo.map(
                          (Pokemon pokemon) => DataColumn(
                            label: SizedBox(
                              width: 96,
                              child: Text(
                                _etiquetaPokemonCompacta(pokemon),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12.5),
                              ),
                            ),
                          ),
                        ),
                        const DataColumn(label: Text('Riesgo')),
                      ],
                      rows: filas.map(_construirFilaTabla).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<_FilaMatrizDefensiva> _obtenerTop3Riesgos(
    List<_FilaMatrizDefensiva> filas,
  ) {
    final List<_FilaMatrizDefensiva> ordenadas =
        List<_FilaMatrizDefensiva>.from(filas)
          ..sort((_FilaMatrizDefensiva a, _FilaMatrizDefensiva b) {
            final int comparacionDebiles = b.debiles.compareTo(a.debiles);
            if (comparacionDebiles != 0) {
              return comparacionDebiles;
            }

            final int comparacionMuyDebiles = b.muyDebiles.compareTo(
              a.muyDebiles,
            );
            if (comparacionMuyDebiles != 0) {
              return comparacionMuyDebiles;
            }

            final int comparacionSuma = b.sumaMultiplicadores.compareTo(
              a.sumaMultiplicadores,
            );
            if (comparacionSuma != 0) {
              return comparacionSuma;
            }

            return a.tipoAtacante.compareTo(b.tipoAtacante);
          });

    return ordenadas.take(3).toList();
  }

  List<String> _obtenerTiposAtacantes() {
    final List<String> tiposCargados = tablaHashTiposPokemon
        .obtenerClaves()
        .map(_normalizar)
        .where((String tipo) => tipo.isNotEmpty)
        .toList();

    final Set<String> tiposUnicos = <String>{...tiposCargados, ..._tiposBase};
    return tiposUnicos.toList()..sort();
  }

  _FilaMatrizDefensiva _calcularFilaDefensiva(String tipoAtacante) {
    final List<double> multiplicadores = equipo
        .map(
          (Pokemon pokemon) =>
              tablaHashTiposPokemon.obtenerMultiplicadorDefensivo(
                tiposDefensores: pokemon.tipos,
                tipoAtacante: tipoAtacante,
              ),
        )
        .toList();

    final int inmunes = multiplicadores
        .where((double valor) => _esIgual(valor, 0))
        .length;
    final int resistentes = multiplicadores
        .where((double valor) => valor > 0 && valor <= 0.5)
        .length;
    final int debiles = multiplicadores
        .where((double valor) => valor >= 2)
        .length;
    final int muyDebiles = multiplicadores
        .where((double valor) => valor >= 4)
        .length;
    final double sumaMultiplicadores = multiplicadores.fold<double>(
      0,
      (double acumulado, double valor) => acumulado + valor,
    );

    final String riesgo = debiles >= 2
        ? 'Alto'
        : debiles == 1
        ? 'Medio'
        : 'Bajo';

    return _FilaMatrizDefensiva(
      tipoAtacante: tipoAtacante,
      multiplicadores: multiplicadores,
      inmunes: inmunes,
      resistentes: resistentes,
      debiles: debiles,
      muyDebiles: muyDebiles,
      sumaMultiplicadores: sumaMultiplicadores,
      riesgo: riesgo,
    );
  }

  _FilaMatrizDefensiva? _obtenerTipoMasPeligroso(
    List<_FilaMatrizDefensiva> filas,
  ) {
    if (filas.isEmpty) {
      return null;
    }

    final List<_FilaMatrizDefensiva> ordenadas =
        List<_FilaMatrizDefensiva>.from(filas)..sort((
          _FilaMatrizDefensiva a,
          _FilaMatrizDefensiva b,
        ) {
          final int comparacionDebiles = b.debiles.compareTo(a.debiles);
          if (comparacionDebiles != 0) {
            return comparacionDebiles;
          }

          final double maximoA = a.multiplicadores.isEmpty
              ? 0
              : a.multiplicadores.reduce((double x, double y) => x > y ? x : y);
          final double maximoB = b.multiplicadores.isEmpty
              ? 0
              : b.multiplicadores.reduce((double x, double y) => x > y ? x : y);
          final int comparacionMax = maximoB.compareTo(maximoA);
          if (comparacionMax != 0) {
            return comparacionMax;
          }

          return a.tipoAtacante.compareTo(b.tipoAtacante);
        });

    return ordenadas.first;
  }

  DataRow _construirFilaTabla(_FilaMatrizDefensiva fila) {
    return DataRow(
      cells: [
        DataCell(
          ChipTipoPokemon(
            idTipo: _obtenerIdTipo(fila.tipoAtacante),
            nombre: _nombreTipoMostrado(fila.tipoAtacante),
            compacto: true,
            modoBadge: true,
            anchoBadge: 72,
            altoBadge: 24,
          ),
        ),
        ...fila.multiplicadores.map(
          (double valor) => DataCell(
            _ChipMultiplicador(
              texto: _formatearMultiplicador(valor),
              colorFondo: _colorMultiplicador(valor),
              textoClasificacion: _clasificacionMultiplicador(valor),
            ),
          ),
        ),
        DataCell(
          _ChipRiesgo(
            riesgo: fila.riesgo,
            debiles: fila.debiles,
            resistentes: fila.resistentes,
            inmunes: fila.inmunes,
          ),
        ),
      ],
    );
  }

  String _etiquetaPokemonCompacta(Pokemon pokemon) {
    final String nombre = pokemon.nombre.trim().isEmpty
        ? 'pokemon'
        : pokemon.nombre.trim().toLowerCase();
    final String nombreCorto = _acortarTexto(nombre, 9);

    if (pokemon.id != null) {
      return '#${pokemon.id} $nombreCorto';
    }
    return nombreCorto;
  }

  String _acortarTexto(String valor, int maximo) {
    if (valor.length <= maximo) {
      return valor;
    }

    return '${valor.substring(0, maximo - 1)}…';
  }

  String _formatearMultiplicador(double valor) {
    if (_esIgual(valor, 0)) {
      return 'x0';
    }
    if (_esIgual(valor, 0.25)) {
      return 'x0.25';
    }
    if (_esIgual(valor, 0.5)) {
      return 'x0.5';
    }
    if (_esIgual(valor, 1)) {
      return 'x1';
    }
    if (_esIgual(valor, 2)) {
      return 'x2';
    }
    if (_esIgual(valor, 4)) {
      return 'x4';
    }

    if (valor % 1 == 0) {
      return 'x${valor.toStringAsFixed(0)}';
    }
    return 'x${valor.toStringAsFixed(2)}';
  }

  String _clasificacionMultiplicador(double valor) {
    if (_esIgual(valor, 0)) {
      return 'Inmune';
    }
    if (valor > 0 && valor <= 0.5) {
      return 'Resiste';
    }
    if (valor >= 4) {
      return 'Muy débil';
    }
    if (valor >= 2) {
      return 'Débil';
    }
    return 'Neutro';
  }

  Color _colorMultiplicador(double valor) {
    if (_esIgual(valor, 0)) {
      return const Color(0xFFD8F5DD);
    }
    if (valor > 0 && valor <= 0.5) {
      return const Color(0xFFE3F3FF);
    }
    if (valor >= 4) {
      return const Color(0xFFFFCDD2);
    }
    if (valor >= 2) {
      return const Color(0xFFFFE0B2);
    }
    return const Color(0xFFEAEAEA);
  }

  String _capitalizar(String valor) {
    if (valor.isEmpty) {
      return valor;
    }
    return '${valor[0].toUpperCase()}${valor.substring(1)}';
  }

  String _nombreTipoMostrado(String tipoInterno) {
    final String tipoNormalizado = _normalizar(tipoInterno);
    final RelacionesDanioTipo? relaciones = tablaHashTiposPokemon.buscarTipo(
      tipoNormalizado,
    );
    final String nombre = relaciones?.nombreMostrado.trim() ?? '';
    if (nombre.isNotEmpty) {
      return nombre;
    }

    return _capitalizar(tipoNormalizado);
  }

  int? _obtenerIdTipo(String tipoInterno) {
    final String tipoNormalizado = _normalizar(tipoInterno);
    final RelacionesDanioTipo? relaciones = tablaHashTiposPokemon.buscarTipo(
      tipoNormalizado,
    );
    return relaciones?.idTipo;
  }

  bool _hayAmenazaCritica(_FilaMatrizDefensiva? tipoMasPeligroso) {
    if (tipoMasPeligroso == null) {
      return false;
    }

    return tipoMasPeligroso.debiles >= 2 || tipoMasPeligroso.muyDebiles > 0;
  }

  String _generarDiagnostico({
    required _FilaMatrizDefensiva? tipoMasPeligroso,
    required String? tipoMasPeligrosoMostrado,
  }) {
    if (tipoMasPeligroso == null || tipoMasPeligrosoMostrado == null) {
      return 'No hay una amenaza crítica. El equipo tiene cobertura defensiva aceptable.';
    }

    if (tipoMasPeligroso.debiles >= 2) {
      if (tipoMasPeligroso.muyDebiles > 0) {
        return 'Tu equipo tiene mayor riesgo frente a $tipoMasPeligrosoMostrado. '
            'Hay varios Pokémon que reciben daño x2 o más, incluyendo casos x4.';
      }

      return 'Tu equipo tiene mayor riesgo frente a $tipoMasPeligrosoMostrado. '
          'Hay varios Pokémon que reciben daño x2 o más.';
    }

    if (tipoMasPeligroso.debiles == 1) {
      return 'Tu equipo está relativamente equilibrado. La principal amenaza es '
          '$tipoMasPeligrosoMostrado, con una sola debilidad relevante.';
    }

    return 'No hay una amenaza crítica. El equipo tiene cobertura defensiva aceptable.';
  }

  List<String> _generarRecomendaciones(List<_FilaMatrizDefensiva> topRiesgos) {
    final _FilaMatrizDefensiva? tipoMasPeligroso = topRiesgos.isEmpty
        ? null
        : topRiesgos.first;
    if (!_hayAmenazaCritica(tipoMasPeligroso)) {
      return <String>[];
    }

    final Set<String> tiposEquipo = _obtenerTiposDelEquipo();
    final List<_FilaMatrizDefensiva> amenazas = topRiesgos.take(3).toList();
    final List<_RecomendacionTipo> evaluadas = <_RecomendacionTipo>[];

    for (final String candidato in _tiposBase) {
      final String tipoCandidato = _normalizar(candidato);
      if (tipoCandidato.isEmpty) {
        continue;
      }

      final bool yaExisteEnEquipo = tiposEquipo.contains(tipoCandidato);
      bool empeoraAmenazaAlta = false;
      double puntaje = 0;

      for (int i = 0; i < amenazas.length; i++) {
        final _FilaMatrizDefensiva amenaza = amenazas[i];
        final double prioridadPosicion = (3 - i).toDouble();
        final double prioridadSeveridad =
            1 + (amenaza.debiles * 0.35) + (amenaza.muyDebiles * 0.65);
        final double pesoAmenaza = prioridadPosicion * prioridadSeveridad;
        final double factorDefensivo = _obtenerFactorDefensivoCandidato(
          tipoDefensor: tipoCandidato,
          tipoAtacante: amenaza.tipoAtacante,
        );

        if (_esIgual(factorDefensivo, 0)) {
          puntaje += 8 * pesoAmenaza;
        } else if (factorDefensivo <= 0.5) {
          puntaje += 4 * pesoAmenaza;
        } else if (_esIgual(factorDefensivo, 1)) {
          puntaje += 1 * pesoAmenaza;
        } else if (factorDefensivo >= 2) {
          puntaje -= 5 * pesoAmenaza;
          if (amenaza.riesgo == 'Alto') {
            puntaje -= 2.5 * pesoAmenaza;
            empeoraAmenazaAlta = true;
          }
        }
      }

      if (yaExisteEnEquipo) {
        puntaje -= 3.5;
      } else {
        puntaje += 1.0;
      }

      final RelacionesDanioTipo? relaciones = tablaHashTiposPokemon.buscarTipo(
        tipoCandidato,
      );
      if (relaciones == null) {
        puntaje -= 1.0;
      }

      if (empeoraAmenazaAlta) {
        puntaje -= 6;
      }

      evaluadas.add(
        _RecomendacionTipo(
          tipo: tipoCandidato,
          puntaje: puntaje,
          yaExisteEnEquipo: yaExisteEnEquipo,
          empeoraAmenazaAlta: empeoraAmenazaAlta,
        ),
      );
    }

    evaluadas.sort((_RecomendacionTipo a, _RecomendacionTipo b) {
      final int comparacionPuntaje = b.puntaje.compareTo(a.puntaje);
      if (comparacionPuntaje != 0) {
        return comparacionPuntaje;
      }

      if (a.yaExisteEnEquipo != b.yaExisteEnEquipo) {
        return a.yaExisteEnEquipo ? 1 : -1;
      }

      return a.tipo.compareTo(b.tipo);
    });

    final List<String> recomendados = evaluadas
        .where(
          (_RecomendacionTipo item) =>
              item.puntaje > 0 &&
              !item.empeoraAmenazaAlta &&
              !item.yaExisteEnEquipo,
        )
        .take(3)
        .map((_RecomendacionTipo item) => item.tipo)
        .toList();

    if (recomendados.length >= 3) {
      return recomendados;
    }

    final Set<String> recomendadosSet = recomendados.toSet();
    for (final _RecomendacionTipo item in evaluadas) {
      if (recomendadosSet.contains(item.tipo)) {
        continue;
      }
      if (item.puntaje <= 0 || item.empeoraAmenazaAlta) {
        continue;
      }
      recomendados.add(item.tipo);
      recomendadosSet.add(item.tipo);
      if (recomendados.length == 3) {
        break;
      }
    }

    return recomendados;
  }

  Set<String> _obtenerTiposDelEquipo() {
    final Set<String> tipos = <String>{};
    for (final Pokemon pokemon in equipo) {
      for (final String tipo in pokemon.tipos) {
        final String normalizado = _normalizar(tipo);
        if (normalizado.isNotEmpty) {
          tipos.add(normalizado);
        }
      }
    }
    return tipos;
  }

  double _obtenerFactorDefensivoCandidato({
    required String tipoDefensor,
    required String tipoAtacante,
  }) {
    final RelacionesDanioTipo? relaciones = tablaHashTiposPokemon.buscarTipo(
      _normalizar(tipoDefensor),
    );
    if (relaciones == null) {
      return 1;
    }

    final String atacante = _normalizar(tipoAtacante);
    if (_contieneTipo(relaciones.sinDanioDe, atacante)) {
      return 0;
    }
    if (_contieneTipo(relaciones.medioDanioDe, atacante)) {
      return 0.5;
    }
    if (_contieneTipo(relaciones.dobleDanioDe, atacante)) {
      return 2;
    }

    return 1;
  }

  bool _contieneTipo(List<String> tipos, String tipoBuscado) {
    for (final String tipo in tipos) {
      if (_normalizar(tipo) == tipoBuscado) {
        return true;
      }
    }
    return false;
  }

  String _normalizar(String valor) {
    return valor.trim().toLowerCase();
  }

  bool _esIgual(double a, double b) {
    return (a - b).abs() < 0.001;
  }
}

class _FilaMatrizDefensiva {
  const _FilaMatrizDefensiva({
    required this.tipoAtacante,
    required this.multiplicadores,
    required this.inmunes,
    required this.resistentes,
    required this.debiles,
    required this.muyDebiles,
    required this.sumaMultiplicadores,
    required this.riesgo,
  });

  final String tipoAtacante;
  final List<double> multiplicadores;
  final int inmunes;
  final int resistentes;
  final int debiles;
  final int muyDebiles;
  final double sumaMultiplicadores;
  final String riesgo;
}

class _RecomendacionTipo {
  const _RecomendacionTipo({
    required this.tipo,
    required this.puntaje,
    required this.yaExisteEnEquipo,
    required this.empeoraAmenazaAlta,
  });

  final String tipo;
  final double puntaje;
  final bool yaExisteEnEquipo;
  final bool empeoraAmenazaAlta;
}

class _TarjetaTopRiesgos extends StatelessWidget {
  const _TarjetaTopRiesgos({
    required this.filasTopRiesgo,
    required this.resolverNombreTipo,
    required this.resolverIdTipo,
  });

  final List<_FilaMatrizDefensiva> filasTopRiesgo;
  final String Function(String tipoInterno) resolverNombreTipo;
  final int? Function(String tipoInterno) resolverIdTipo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top 3 tipos más peligrosos',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...filasTopRiesgo.map((_FilaMatrizDefensiva fila) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ChipTipoPokemon(
                        idTipo: resolverIdTipo(fila.tipoAtacante),
                        nombre: resolverNombreTipo(fila.tipoAtacante),
                        modoBadge: true,
                        compacto: true,
                        anchoBadge: 72,
                        altoBadge: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text('Débiles: ${fila.debiles}'),
                            Text('Muy débiles: ${fila.muyDebiles}'),
                            _EtiquetaRiesgoCompacta(riesgo: fila.riesgo),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _TarjetaDiagnostico extends StatelessWidget {
  const _TarjetaDiagnostico({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Diagnóstico',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(texto),
          ],
        ),
      ),
    );
  }
}

class _TarjetaRecomendaciones extends StatelessWidget {
  const _TarjetaRecomendaciones({
    required this.recomendaciones,
    required this.hayAmenazaCritica,
    required this.resolverNombreTipo,
    required this.resolverIdTipo,
  });

  final List<String> recomendaciones;
  final bool hayAmenazaCritica;
  final String Function(String tipoInterno) resolverNombreTipo;
  final int? Function(String tipoInterno) resolverIdTipo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recomendaciones defensivas',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (!hayAmenazaCritica || recomendaciones.isEmpty)
              const Text(
                'No hay una amenaza crítica. El equipo tiene cobertura defensiva aceptable.',
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: recomendaciones
                    .take(3)
                    .map(
                      (String tipo) => ChipTipoPokemon(
                        idTipo: resolverIdTipo(tipo),
                        nombre: resolverNombreTipo(tipo),
                        modoBadge: true,
                        anchoBadge: 82,
                        altoBadge: 26,
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _EtiquetaRiesgoCompacta extends StatelessWidget {
  const _EtiquetaRiesgoCompacta({required this.riesgo});

  final String riesgo;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (riesgo) {
      'Alto' => Colors.red.shade700,
      'Medio' => Colors.orange.shade700,
      _ => Colors.green.shade700,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        riesgo,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: color,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _ResumenAnalisisBasico extends StatelessWidget {
  const _ResumenAnalisisBasico({
    required this.cantidadPokemon,
    required this.cantidadTiposCargados,
    required this.tipoMasPeligroso,
    required this.vulnerabilidadesTotales,
  });

  final int cantidadPokemon;
  final int cantidadTiposCargados;
  final String? tipoMasPeligroso;
  final int vulnerabilidadesTotales;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FichaResumen(
              titulo: 'Pokémon analizados',
              valor: '$cantidadPokemon',
            ),
            _FichaResumen(
              titulo: 'Tipos cargados',
              valor: '$cantidadTiposCargados',
            ),
            _FichaResumen(
              titulo: 'Más peligroso',
              valor: tipoMasPeligroso ?? '-',
            ),
            _FichaResumen(
              titulo: 'Vulnerabilidades',
              valor: '$vulnerabilidadesTotales',
            ),
          ],
        ),
      ),
    );
  }
}

class _FichaResumen extends StatelessWidget {
  const _FichaResumen({required this.titulo, required this.valor});

  final String titulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 2),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _ChipMultiplicador extends StatelessWidget {
  const _ChipMultiplicador({
    required this.texto,
    required this.textoClasificacion,
    required this.colorFondo,
  });

  final String texto;
  final String textoClasificacion;
  final Color colorFondo;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: textoClasificacion,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: colorFondo,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          texto,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ),
    );
  }
}

class _ChipRiesgo extends StatelessWidget {
  const _ChipRiesgo({
    required this.riesgo,
    required this.debiles,
    required this.resistentes,
    required this.inmunes,
  });

  final String riesgo;
  final int debiles;
  final int resistentes;
  final int inmunes;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (riesgo) {
      'Alto' => Colors.red.shade700,
      'Medio' => Colors.orange.shade700,
      _ => Colors.green.shade700,
    };

    return Tooltip(
      message:
          'Débiles: $debiles • Resistentes: $resistentes • Inmunes: $inmunes',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          riesgo,
          style: TextStyle(fontWeight: FontWeight.w700, color: color),
        ),
      ),
    );
  }
}
