import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/datos/servicios/servicio_pokeapi.dart';
import 'package:proyecto_final_progra3/dominio/entidades/equipo_guardado_pokemon.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/dominio/entidades/relaciones_danio_tipo.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/equipo_pokemon.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/equipos_recientes_pokemon.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/tabla_hash_tipos_pokemon.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/tabla_hash_pokemon/pestana_analisis_hash.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/tabla_hash_pokemon/pestana_equipo_hash.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/tabla_hash_pokemon/pestana_recientes_hash.dart';

class PantallaTablaHashPokemon extends StatefulWidget {
  const PantallaTablaHashPokemon({super.key});

  @override
  State<PantallaTablaHashPokemon> createState() =>
      _PantallaTablaHashPokemonState();
}

class _PantallaTablaHashPokemonState extends State<PantallaTablaHashPokemon> {
  static const List<String> _tiposBaseAnalisis = <String>[
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

  final ServicioPokeapi _servicioPokeapi = ServicioPokeapi();
  final EquipoPokemon _equipoPokemon = EquipoPokemon();
  final TablaHashTiposPokemon _tablaTiposPokemon = TablaHashTiposPokemon();
  final EquiposRecientesPokemon _equiposRecientesPokemon =
      EquiposRecientesPokemon();

  final TextEditingController _controladorAgregar = TextEditingController();
  final TextEditingController _controladorBuscarPokemon =
      TextEditingController();
  final TextEditingController _controladorBuscarTipo = TextEditingController();

  Pokemon? _pokemonEncontrado;
  RelacionesDanioTipo? _tipoEncontrado;
  bool _seBuscoPokemon = false;
  bool _seBuscoTipo = false;
  bool _cargandoAgregar = false;
  bool _cargandoRecientes = false;
  bool _cargandoTiposAnalisis = false;

  @override
  void dispose() {
    _controladorAgregar.dispose();
    _controladorBuscarPokemon.dispose();
    _controladorBuscarTipo.dispose();
    super.dispose();
  }

  Future<void> _agregarPokemonAlEquipo() async {
    final String valorBusqueda = _controladorAgregar.text.trim();
    if (valorBusqueda.isEmpty) {
      _mostrarMensaje('Ingresa nombre o ID del Pokémon.', esError: true);
      return;
    }

    if (_equipoPokemon.estaLleno) {
      _mostrarMensaje('El equipo ya está lleno (máximo 6).', esError: true);
      return;
    }

    setState(() {
      _cargandoAgregar = true;
    });

    try {
      final Pokemon pokemon = await _servicioPokeapi.obtenerPokemonDetalle(
        valorBusqueda,
      );

      if (_esDuplicadoEnEquipo(pokemon)) {
        _mostrarMensaje('Ese Pokémon ya existe en el equipo.', esError: true);
        return;
      }

      final bool agregado = _equipoPokemon.agregarPokemon(pokemon);
      if (!agregado) {
        _mostrarMensaje(
          'No se pudo agregar el Pokémon al equipo.',
          esError: true,
        );
        return;
      }

      final List<Pokemon> equipoActual = _equipoPokemon.obtenerEquipo();
      final int tiposCargados = await _cargarTiposNecesariosParaAnalisis(
        pokemonesEquipo: equipoActual,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _controladorAgregar.clear();
      });

      _mostrarMensaje(
        'Pokémon agregado: ${pokemon.nombre}. Tipos cargados: $tiposCargados.',
      );
    } catch (error) {
      _mostrarMensaje('Error al agregar Pokémon: $error', esError: true);
    } finally {
      if (mounted) {
        setState(() {
          _cargandoAgregar = false;
        });
      }
    }
  }

  bool _esDuplicadoEnEquipo(Pokemon pokemon) {
    if (pokemon.id != null && _equipoPokemon.buscarPorId(pokemon.id!) != null) {
      return true;
    }

    return _equipoPokemon.buscarPorNombre(pokemon.nombre) != null;
  }

  void _eliminarPokemonDelEquipo(Pokemon pokemon) {
    final bool eliminado = pokemon.id != null
        ? _equipoPokemon.eliminarPorId(pokemon.id!)
        : _equipoPokemon.eliminarPorNombre(pokemon.nombre);

    if (!eliminado) {
      _mostrarMensaje('No se pudo eliminar el Pokémon.', esError: true);
      return;
    }

    setState(() {
      if (_pokemonEncontrado != null) {
        final bool coincidePorId =
            _pokemonEncontrado!.id != null &&
            pokemon.id != null &&
            _pokemonEncontrado!.id == pokemon.id;
        final bool coincidePorNombre =
            _normalizar(_pokemonEncontrado!.nombre) ==
            _normalizar(pokemon.nombre);
        if (coincidePorId || coincidePorNombre) {
          _pokemonEncontrado = null;
          _seBuscoPokemon = false;
        }
      }
    });

    _mostrarMensaje('Pokémon eliminado del equipo.');
  }

  void _buscarPokemonEnEquipo() {
    final String criterio = _controladorBuscarPokemon.text.trim();
    final int? idBuscado = int.tryParse(criterio);

    setState(() {
      _seBuscoPokemon = criterio.isNotEmpty;
      if (!_seBuscoPokemon) {
        _pokemonEncontrado = null;
        return;
      }

      _pokemonEncontrado = idBuscado != null
          ? _equipoPokemon.buscarPorId(idBuscado) ??
                _equipoPokemon.buscarPorNombre(criterio)
          : _equipoPokemon.buscarPorNombre(criterio);
    });
  }

  void _buscarTipoEnTabla() {
    final String tipo = _controladorBuscarTipo.text.trim();

    setState(() {
      _seBuscoTipo = tipo.isNotEmpty;
      if (!_seBuscoTipo) {
        _tipoEncontrado = null;
        return;
      }

      _tipoEncontrado = _tablaTiposPokemon.buscarTipo(tipo);
      if (_tipoEncontrado != null) {
        return;
      }

      final String textoBusqueda = _normalizarTextoBusqueda(tipo);
      for (final RelacionesDanioTipo relaciones
          in _tablaTiposPokemon.obtenerTodos()) {
        final String nombreMostrado = _normalizarTextoBusqueda(
          relaciones.nombreMostrado,
        );
        if (textoBusqueda == nombreMostrado) {
          _tipoEncontrado = relaciones;
          return;
        }
      }
    });

    if (_seBuscoTipo && _tipoEncontrado == null) {
      _mostrarMensaje(
        'Tipo no cargado en la tabla hash. Agrega un Pokémon de ese tipo para cargarlo.',
        esError: true,
      );
    }
  }

  void _guardarEquipoActualEnRecientes() {
    final List<Pokemon> equipoActual = _equipoPokemon.obtenerEquipo();
    if (equipoActual.length != 6) {
      _mostrarMensaje(
        'Solo puedes guardar equipos completos de 6 Pokémon.',
        esError: true,
      );
      return;
    }

    final EquipoGuardadoPokemon? guardado = _equiposRecientesPokemon
        .guardarEquipo(equipoActual);

    if (guardado == null) {
      _mostrarMensaje(
        'Ese equipo ya está guardado en Recientes.',
        esError: true,
      );
      return;
    }

    setState(() {});
    _mostrarMensaje('Equipo guardado en Recientes: ${guardado.nombre}.');
  }

  Future<void> _cargarEquipoReciente(String idEquipo) async {
    final EquipoGuardadoPokemon? guardado = _equiposRecientesPokemon
        .buscarPorId(idEquipo);
    if (guardado == null) {
      _mostrarMensaje('No se encontró el equipo seleccionado.', esError: true);
      return;
    }

    setState(() {
      _cargandoRecientes = true;
    });

    try {
      final List<Pokemon> snapshot = guardado.pokemones;
      if (snapshot.length != 6) {
        _mostrarMensaje(
          'El equipo guardado no tiene 6 Pokémon.',
          esError: true,
        );
        return;
      }

      _equipoPokemon.limpiar();
      for (final Pokemon pokemon in snapshot) {
        final bool agregado = _equipoPokemon.agregarPokemon(pokemon);
        if (!agregado) {
          throw Exception(
            'No se pudo restaurar el equipo guardado correctamente.',
          );
        }
      }

      await _cargarTiposNecesariosParaAnalisis(pokemonesEquipo: snapshot);

      if (!mounted) {
        return;
      }

      setState(() {
        _pokemonEncontrado = null;
        _tipoEncontrado = null;
        _seBuscoPokemon = false;
        _seBuscoTipo = false;
      });

      final String fecha = _formatearFechaHora(guardado.fechaGuardado);
      _mostrarMensaje('Equipo cargado: ${guardado.nombre} ($fecha).');
    } catch (error) {
      _mostrarMensaje('Error al cargar equipo reciente: $error', esError: true);
    } finally {
      if (mounted) {
        setState(() {
          _cargandoRecientes = false;
        });
      }
    }
  }

  void _eliminarEquipoReciente(String idEquipo) {
    final bool eliminado = _equiposRecientesPokemon.eliminarPorId(idEquipo);
    if (!eliminado) {
      _mostrarMensaje('No se pudo eliminar el equipo reciente.', esError: true);
      return;
    }

    setState(() {});
    _mostrarMensaje('Equipo reciente eliminado.');
  }

  void _limpiarEquiposRecientes() {
    if (_equiposRecientesPokemon.estaVacio) {
      _mostrarMensaje('No hay equipos recientes para limpiar.', esError: true);
      return;
    }

    _equiposRecientesPokemon.limpiar();
    setState(() {});
    _mostrarMensaje('Equipos recientes limpiados.');
  }

  Future<int> _cargarTiposNecesariosParaAnalisis({
    required List<Pokemon> pokemonesEquipo,
  }) async {
    if (_cargandoTiposAnalisis) {
      return 0;
    }

    if (mounted) {
      setState(() {
        _cargandoTiposAnalisis = true;
      });
    }

    int tiposCargados = 0;
    try {
      final Set<String> pendientes = _recolectarTiposNecesarios(
        pokemonesEquipo: pokemonesEquipo,
      );
      final Set<String> procesados = <String>{};

      while (pendientes.isNotEmpty) {
        final String tipo = pendientes.first;
        pendientes.remove(tipo);

        if (procesados.contains(tipo) ||
            _tablaTiposPokemon.contieneTipo(tipo)) {
          continue;
        }

        final RelacionesDanioTipo relaciones = await _servicioPokeapi
            .obtenerRelacionesDanioTipo(tipo);
        _tablaTiposPokemon.insertarTipo(relaciones);
        tiposCargados++;
        procesados.add(tipo);

        pendientes.addAll(_recolectarTiposDesdeRelaciones(relaciones));
      }

      return tiposCargados;
    } finally {
      if (mounted) {
        setState(() {
          _cargandoTiposAnalisis = false;
        });
      }
    }
  }

  Set<String> _recolectarTiposNecesarios({
    required List<Pokemon> pokemonesEquipo,
  }) {
    final Set<String> tipos = <String>{..._tiposBaseAnalisis};

    for (final Pokemon pokemon in pokemonesEquipo) {
      tipos.addAll(
        pokemon.tipos.map(_normalizar).where((String tipo) => tipo.isNotEmpty),
      );
    }

    for (final RelacionesDanioTipo relaciones
        in _tablaTiposPokemon.obtenerTodos()) {
      tipos.add(_normalizar(relaciones.tipo));
      tipos.addAll(_recolectarTiposDesdeRelaciones(relaciones));
    }

    tipos.removeWhere((String tipo) => tipo.trim().isEmpty);
    return tipos;
  }

  Set<String> _recolectarTiposDesdeRelaciones(RelacionesDanioTipo relaciones) {
    final Set<String> tipos = <String>{};

    tipos.addAll(
      relaciones.sinDanioDe
          .map(_normalizar)
          .where((String tipo) => tipo.isNotEmpty),
    );
    tipos.addAll(
      relaciones.medioDanioDe
          .map(_normalizar)
          .where((String tipo) => tipo.isNotEmpty),
    );
    tipos.addAll(
      relaciones.dobleDanioDe
          .map(_normalizar)
          .where((String tipo) => tipo.isNotEmpty),
    );

    return tipos;
  }

  void _mostrarMensaje(String mensaje, {bool esError = false}) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? Colors.red.shade700 : Colors.green.shade700,
      ),
    );
  }

  String _estadoEquipo() {
    if (_equipoPokemon.estaVacio) {
      return 'Vacío';
    }
    if (_equipoPokemon.estaLleno) {
      return 'Lleno';
    }
    return 'Incompleto';
  }

  Color _colorEstadoEquipo() {
    if (_equipoPokemon.estaVacio) {
      return Colors.grey.shade700;
    }
    if (_equipoPokemon.estaLleno) {
      return Colors.green.shade700;
    }
    return Colors.orange.shade800;
  }

  String _normalizar(String valor) {
    return valor.trim().toLowerCase();
  }

  String _normalizarTextoBusqueda(String valor) {
    return _normalizar(valor)
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u');
  }

  String _nombreTipoMostrado(String tipoInterno) {
    final String clave = _normalizar(tipoInterno);
    if (clave.isEmpty) {
      return tipoInterno;
    }

    final RelacionesDanioTipo? relaciones = _relacionesTipo(clave);
    final String nombre = relaciones?.nombreMostrado.trim() ?? '';
    return nombre.isEmpty ? tipoInterno : nombre;
  }

  RelacionesDanioTipo? _relacionesTipo(String tipoInterno) {
    final String clave = _normalizar(tipoInterno);
    if (clave.isEmpty) {
      return null;
    }

    return _tablaTiposPokemon.buscarTipo(clave);
  }

  String _formatearFechaHora(DateTime fecha) {
    final String dia = fecha.day.toString().padLeft(2, '0');
    final String mes = fecha.month.toString().padLeft(2, '0');
    final String anio = fecha.year.toString();
    final String hora = fecha.hour.toString().padLeft(2, '0');
    final String minuto = fecha.minute.toString().padLeft(2, '0');
    return '$dia/$mes/$anio $hora:$minuto';
  }

  @override
  Widget build(BuildContext context) {
    final List<Pokemon> equipoActual = _equipoPokemon.obtenerEquipo();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analizador de Equipos'),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(icon: Icon(Icons.groups_rounded), text: 'Equipo'),
              Tab(icon: Icon(Icons.history_rounded), text: 'Recientes'),
              Tab(icon: Icon(Icons.analytics_rounded), text: 'Análisis'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PestanaEquipoHash(
              controladorAgregar: _controladorAgregar,
              controladorBuscarPokemon: _controladorBuscarPokemon,
              controladorBuscarTipo: _controladorBuscarTipo,
              cargandoAgregar: _cargandoAgregar,
              cantidadEquipo: _equipoPokemon.cantidad,
              cantidadTipos: _tablaTiposPokemon.cantidad,
              estadoEquipo: _estadoEquipo(),
              colorEstado: _colorEstadoEquipo(),
              equipo: equipoActual,
              seBuscoPokemon: _seBuscoPokemon,
              pokemonEncontrado: _pokemonEncontrado,
              seBuscoTipo: _seBuscoTipo,
              tipoEncontrado: _tipoEncontrado,
              onAgregarPokemon: _agregarPokemonAlEquipo,
              onBuscarPokemon: _buscarPokemonEnEquipo,
              onBuscarTipo: _buscarTipoEnTabla,
              resolverNombreTipo: _nombreTipoMostrado,
              resolverRelacionesTipo: _relacionesTipo,
              onEliminarPokemon: _eliminarPokemonDelEquipo,
              onGuardarEquipo: _guardarEquipoActualEnRecientes,
              puedeGuardarEquipo:
                  _equipoPokemon.cantidad == 6 && !_cargandoRecientes,
            ),
            PestanaRecientesHash(
              equiposRecientes: _equiposRecientesPokemon.obtenerTodos(),
              cargandoOperacion: _cargandoRecientes,
              onCargarEquipo: _cargarEquipoReciente,
              onEliminarEquipo: _eliminarEquipoReciente,
              onLimpiarRecientes: _limpiarEquiposRecientes,
            ),
            PestanaAnalisisHash(
              equipo: equipoActual,
              tablaHashTiposPokemon: _tablaTiposPokemon,
              cargandoTipos: _cargandoTiposAnalisis,
            ),
          ],
        ),
      ),
    );
  }
}
