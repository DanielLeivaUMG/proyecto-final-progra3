import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/dominio/entidades/relaciones_danio_tipo.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/tabla_hash_tipos_pokemon.dart';

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
    final String? tipoMasPeligrosoMostrado = tipoMasPeligroso == null
        ? null
        : _nombreTipoMostrado(tipoMasPeligroso.tipoAtacante);

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
        DataCell(Text(_nombreTipoMostrado(fila.tipoAtacante))),
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
    required this.riesgo,
  });

  final String tipoAtacante;
  final List<double> multiplicadores;
  final int inmunes;
  final int resistentes;
  final int debiles;
  final String riesgo;
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
