import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/datos/servicios/servicio_pokeapi.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon_coleccion.dart';
import 'package:proyecto_final_progra3/dominio/entidades/relaciones_danio_tipo.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/lista_enlazada_living_dex.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/lista_pokemon/pestana_cadena_lista.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/lista_pokemon/pestana_operaciones_lista.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/lista_pokemon/pestana_resumen_lista.dart';

enum _ModoUbicacionColeccion { finalColeccion, despuesDeOtro }

class PantallaListaPokemon extends StatefulWidget {
  const PantallaListaPokemon({super.key});

  @override
  State<PantallaListaPokemon> createState() => _PantallaListaPokemonState();
}

class _PantallaListaPokemonState extends State<PantallaListaPokemon> {
  final ServicioPokeapi _servicioPokeapi = ServicioPokeapi();
  final ListaEnlazadaLivingDex _livingDex = ListaEnlazadaLivingDex();

  final TextEditingController _controladorBusquedaApi = TextEditingController();
  final TextEditingController _controladorUbicacionDespuesDe =
      TextEditingController();

  final Map<String, RelacionesDanioTipo> _cacheTipos =
      <String, RelacionesDanioTipo>{};

  Pokemon? _pokemonApiEncontrado;
  bool _cargandoBusquedaApi = false;
  bool _esShinyParaAgregar = false;
  EstadoColeccionPokemon _estadoParaAgregar = EstadoColeccionPokemon.pendiente;
  _ModoUbicacionColeccion _modoUbicacion =
      _ModoUbicacionColeccion.finalColeccion;

  @override
  void dispose() {
    _controladorBusquedaApi.dispose();
    _controladorUbicacionDespuesDe.dispose();
    super.dispose();
  }

  Future<void> _buscarPokemonEnApi() async {
    final String criterio = _controladorBusquedaApi.text.trim();
    if (criterio.isEmpty) {
      _mostrarMensaje('Ingresa un nombre o ID para buscar.', esError: true);
      return;
    }

    setState(() {
      _cargandoBusquedaApi = true;
    });

    try {
      final Pokemon pokemon = await _servicioPokeapi.obtenerPokemonDetalle(
        criterio,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _pokemonApiEncontrado = pokemon;
      });
      _mostrarMensaje('Pokemon encontrado: ${_capitalizar(pokemon.nombre)}.');

      await _cargarTiposSiHaceFalta(pokemon.tipos);
      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      _mostrarMensaje('No se pudo buscar en PokeAPI: $error', esError: true);
    } finally {
      if (mounted) {
        setState(() {
          _cargandoBusquedaApi = false;
        });
      }
    }
  }

  Future<void> _cargarTiposSiHaceFalta(List<String> tipos) async {
    for (final String tipo in tipos) {
      final String clave = _normalizar(tipo);
      if (clave.isEmpty || _cacheTipos.containsKey(clave)) {
        continue;
      }

      try {
        final RelacionesDanioTipo relaciones = await _servicioPokeapi
            .obtenerRelacionesDanioTipo(clave);
        _cacheTipos[clave] = relaciones;
      } catch (_) {
        // Si falla la carga del icono de tipo, la UI mantiene fallback textual.
      }
    }
  }

  void _agregarPokemonAColeccion() {
    final Pokemon? pokemon = _pokemonApiEncontrado;
    if (pokemon == null) {
      _mostrarMensaje(
        'Primero busca un Pokemon en PokeAPI para agregarlo.',
        esError: true,
      );
      return;
    }

    final PokemonColeccion nuevoItem = PokemonColeccion(
      pokemon: pokemon,
      estado: _estadoParaAgregar,
      esShiny: _esShinyParaAgregar,
      fechaRegistro: DateTime.now(),
    );

    bool agregado = false;
    if (_modoUbicacion == _ModoUbicacionColeccion.finalColeccion) {
      agregado = _livingDex.insertarAlFinal(nuevoItem);
    } else {
      final String referencia = _controladorUbicacionDespuesDe.text.trim();
      if (referencia.isEmpty) {
        _mostrarMensaje(
          'Ingresa despues de que Pokemon quieres colocarlo.',
          esError: true,
        );
        return;
      }
      agregado = _livingDex.insertarDespuesDe(
        referencia: referencia,
        nuevo: nuevoItem,
      );
    }

    if (!agregado) {
      _mostrarMensaje(
        'No se pudo agregar. Revisa si ya existe o si el Pokemon de referencia no esta en tu coleccion.',
        esError: true,
      );
      return;
    }

    setState(() {
      _controladorUbicacionDespuesDe.clear();
    });
    _mostrarMensaje('Pokemon agregado a tu coleccion.');
  }

  Future<bool> _quitarPokemonDeColeccion(PokemonColeccion item) async {
    final String criterio = item.pokemon.id?.toString() ?? item.pokemon.nombre;
    final bool eliminado = _livingDex.eliminarPorNombreOId(criterio);

    if (!eliminado) {
      _mostrarMensaje(
        'No se pudo quitar ese Pokemon de tu coleccion.',
        esError: true,
      );
      return false;
    }

    setState(() {});
    _mostrarMensaje('Pokemon quitado de tu coleccion.');
    return true;
  }

  void _reordenarColeccion(int oldIndex, int newIndex) {
    final List<PokemonColeccion> actuales = _livingDex.obtenerTodos();
    if (oldIndex < 0 ||
        oldIndex >= actuales.length ||
        newIndex < 0 ||
        newIndex > actuales.length) {
      return;
    }

    int destino = newIndex;
    if (destino > oldIndex) {
      destino -= 1;
    }

    final PokemonColeccion movido = actuales.removeAt(oldIndex);
    actuales.insert(destino, movido);

    _livingDex.limpiar();
    for (final PokemonColeccion item in actuales) {
      _livingDex.insertarAlFinal(item);
    }

    setState(() {});
    _mostrarMensaje('Orden de tu coleccion actualizado.');
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

  String _capitalizar(String texto) {
    if (texto.isEmpty) {
      return texto;
    }
    return '${texto[0].toUpperCase()}${texto.substring(1)}';
  }

  String _normalizar(String texto) {
    return texto.trim().toLowerCase();
  }

  String _nombreEstado(EstadoColeccionPokemon estado) {
    switch (estado) {
      case EstadoColeccionPokemon.capturado:
        return 'Capturado';
      case EstadoColeccionPokemon.pendiente:
        return 'Pendiente';
      case EstadoColeccionPokemon.deseado:
        return 'Deseado';
      case EstadoColeccionPokemon.intercambiable:
        return 'Intercambiable';
    }
  }

  int? _resolverIdTipo(String tipoInterno) {
    return _cacheTipos[_normalizar(tipoInterno)]?.idTipo;
  }

  String _resolverNombreTipo(String tipoInterno) {
    final RelacionesDanioTipo? relaciones =
        _cacheTipos[_normalizar(tipoInterno)];
    final String nombreMostrado = relaciones?.nombreMostrado.trim() ?? '';
    if (nombreMostrado.isNotEmpty) {
      return nombreMostrado;
    }
    return _capitalizar(tipoInterno);
  }

  @override
  Widget build(BuildContext context) {
    final List<PokemonColeccion> coleccion = _livingDex.obtenerTodos();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Organizador de colecciones'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(
                icon: Icon(Icons.add_circle_outline_rounded),
                text: 'Agregar',
              ),
              Tab(icon: Icon(Icons.link_rounded), text: 'Mi colección'),
              Tab(icon: Icon(Icons.analytics_rounded), text: 'Resumen'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PestanaOperacionesLista(
              controladorBusquedaApi: _controladorBusquedaApi,
              controladorUbicacionDespuesDe: _controladorUbicacionDespuesDe,
              cargandoBusquedaApi: _cargandoBusquedaApi,
              pokemonApiEncontrado: _pokemonApiEncontrado,
              estadoParaAgregar: _estadoParaAgregar,
              esShinyParaAgregar: _esShinyParaAgregar,
              modoUbicacion:
                  _modoUbicacion == _ModoUbicacionColeccion.finalColeccion
                  ? ModoUbicacionAgregar.finalColeccion
                  : ModoUbicacionAgregar.despuesDeOtro,
              onBuscarPokemonApi: _buscarPokemonEnApi,
              onCambiarEstadoParaAgregar: (EstadoColeccionPokemon estado) {
                setState(() {
                  _estadoParaAgregar = estado;
                });
              },
              onCambiarShinyParaAgregar: (bool valor) {
                setState(() {
                  _esShinyParaAgregar = valor;
                });
              },
              onCambiarModoUbicacion: (ModoUbicacionAgregar modo) {
                setState(() {
                  _modoUbicacion = modo == ModoUbicacionAgregar.finalColeccion
                      ? _ModoUbicacionColeccion.finalColeccion
                      : _ModoUbicacionColeccion.despuesDeOtro;
                });
              },
              onAgregarAColeccion: _agregarPokemonAColeccion,
              resolverNombreEstado: _nombreEstado,
              resolverIdTipo: _resolverIdTipo,
              resolverNombreTipo: _resolverNombreTipo,
            ),
            PestanaCadenaLista(
              cadena: coleccion,
              resolverNombreEstado: _nombreEstado,
              resolverIdTipo: _resolverIdTipo,
              resolverNombreTipo: _resolverNombreTipo,
              onQuitarPokemon: _quitarPokemonDeColeccion,
              onReordenarColeccion: _reordenarColeccion,
            ),
            PestanaResumenLista(
              cadena: coleccion,
              resolverNombreEstado: _nombreEstado,
              primero: _livingDex.obtenerPrimero(),
              ultimo: _livingDex.obtenerUltimo(),
              totalNodos: _livingDex.contarNodos(),
            ),
          ],
        ),
      ),
    );
  }
}
