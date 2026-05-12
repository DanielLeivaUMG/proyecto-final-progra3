import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/datos/servicios/servicio_pokeapi.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/dominio/entidades/relaciones_danio_tipo.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/equipo_pokemon.dart';
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
  final ServicioPokeapi _servicioPokeapi = ServicioPokeapi();
  final EquipoPokemon _equipoPokemon = EquipoPokemon();
  final TablaHashTiposPokemon _tablaTiposPokemon = TablaHashTiposPokemon();

  final TextEditingController _controladorAgregar = TextEditingController();
  final TextEditingController _controladorBuscarPokemon =
      TextEditingController();
  final TextEditingController _controladorBuscarTipo = TextEditingController();

  Pokemon? _pokemonEncontrado;
  RelacionesDanioTipo? _tipoEncontrado;
  bool _seBuscoPokemon = false;
  bool _seBuscoTipo = false;
  bool _cargandoAgregar = false;

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

      int tiposCargados = 0;
      for (final String tipo in pokemon.tipos) {
        if (_tablaTiposPokemon.contieneTipo(tipo)) {
          continue;
        }

        final RelacionesDanioTipo relaciones = await _servicioPokeapi
            .obtenerRelacionesDanioTipo(tipo);
        _tablaTiposPokemon.insertarTipo(relaciones);
        tiposCargados++;
      }

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
    });

    if (_seBuscoTipo && _tipoEncontrado == null) {
      _mostrarMensaje(
        'Tipo no cargado en la tabla hash. Agrega un Pokémon de ese tipo para cargarlo.',
        esError: true,
      );
    }
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

  @override
  Widget build(BuildContext context) {
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
              equipo: _equipoPokemon.obtenerEquipo(),
              seBuscoPokemon: _seBuscoPokemon,
              pokemonEncontrado: _pokemonEncontrado,
              seBuscoTipo: _seBuscoTipo,
              tipoEncontrado: _tipoEncontrado,
              onAgregarPokemon: _agregarPokemonAlEquipo,
              onBuscarPokemon: _buscarPokemonEnEquipo,
              onBuscarTipo: _buscarTipoEnTabla,
              onEliminarPokemon: _eliminarPokemonDelEquipo,
            ),
            const PestanaRecientesHash(),
            const PestanaAnalisisHash(),
          ],
        ),
      ),
    );
  }
}
