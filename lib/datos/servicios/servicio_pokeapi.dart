import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proyecto_final_progra3/datos/modelos/modelo_pokemon.dart';
import 'package:proyecto_final_progra3/datos/modelos/modelo_pokemon_detalle.dart';
import 'package:proyecto_final_progra3/datos/modelos/modelo_relaciones_danio_tipo.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon_carta.dart';
import 'package:proyecto_final_progra3/dominio/entidades/relaciones_danio_tipo.dart';
import 'package:proyecto_final_progra3/dominio/estructuras/arbol_pokemon.dart';
import 'package:proyecto_final_progra3/nucleo/configuracion/configuracion_api.dart';
import 'package:proyecto_final_progra3/nucleo/constantes/api_constantes.dart';

class ServicioPokeapi {
  String obtenerUrlPokemon() {
    return '${ConfiguracionApi.urlBase}${ApiConstantes.endpointPokemon}';
  }

  String obtenerUrlPokemonSpecies() {
    return '${ConfiguracionApi.urlBase}${ApiConstantes.endpointPokemonSpecies}';
  }

  String obtenerUrlTipos() {
    return '${ConfiguracionApi.urlBase}${ApiConstantes.endpointType}';
  }

  Future<List<Pokemon>> obtenerPokemones() async {
    final Uri url = Uri.parse('${obtenerUrlPokemon()}?limit=20&offset=0');
    final http.Response respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final Map<String, dynamic> datos = json.decode(respuesta.body);
      final List<dynamic> resultados = datos['results'] ?? <dynamic>[];

      return resultados
          .map(
            (dynamic item) =>
                ModeloPokemon.fromJson(item as Map<String, dynamic>).aEntidad(),
          )
          .toList();
    } else {
      throw Exception('Error al obtener los pokemones desde la API');
    }
  }

  Future<List<Pokemon>> obtenerPokemonesPaginados({
    int limite = 20,
    int offset = 0,
  }) async {
    final Uri url = Uri.parse(
      '${obtenerUrlPokemon()}?limit=$limite&offset=$offset',
    );
    final http.Response respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final Map<String, dynamic> datos = json.decode(respuesta.body);
      final List<dynamic> resultados = datos['results'] ?? <dynamic>[];

      return resultados
          .map(
            (dynamic item) =>
                ModeloPokemon.fromJson(item as Map<String, dynamic>).aEntidad(),
          )
          .toList();
    } else {
      throw Exception('Error al obtener los pokemones paginados desde la API');
    }
  }

  Future<Pokemon> obtenerPokemonDetalle(String nombreOId) async {
    final String valorBusqueda = nombreOId.trim().toLowerCase();
    if (valorBusqueda.isEmpty) {
      throw Exception('Debes ingresar un Pokemon valido.');
    }

    final Uri url = Uri.parse('${obtenerUrlPokemon()}/$valorBusqueda');
    final http.Response respuesta = await http.get(url);
    if (respuesta.statusCode != 200) {
      throw Exception('No se pudo obtener el detalle del Pokemon solicitado.');
    }

    final Map<String, dynamic> datos =
        json.decode(respuesta.body) as Map<String, dynamic>;
    return ModeloPokemonDetalle.fromJson(
      datos,
      urlBasePokemon: obtenerUrlPokemon(),
    ).aEntidad();
  }

  Future<PokemonCarta> obtenerPokemonCartaDetalle(String nombreOId) async {
    final String valorBusqueda = nombreOId.trim().toLowerCase();

    if (valorBusqueda.isEmpty) {
      throw Exception('Debes ingresar un Pokemon valido.');
    }

    final Uri url = Uri.parse('${obtenerUrlPokemon()}/$valorBusqueda');
    final http.Response respuesta = await http.get(url);

    if (respuesta.statusCode != 200) {
      throw Exception('No se pudo obtener el detalle del Pokemon solicitado.');
    }

    final Map<String, dynamic> datos =
        json.decode(respuesta.body) as Map<String, dynamic>;

    int obtenerStat(String nombreStat) {
      final List<dynamic> stats = datos['stats'] as List<dynamic>? ?? [];

      for (final dynamic item in stats) {
        final Map<String, dynamic> statItem = item as Map<String, dynamic>;
        final Map<String, dynamic> stat =
            statItem['stat'] as Map<String, dynamic>? ?? <String, dynamic>{};

        if (stat['name'] == nombreStat) {
          return statItem['base_stat'] as int? ?? 50;
        }
      }

      return 50;
    }

    final List<dynamic> tipos = datos['types'] as List<dynamic>? ?? [];
    String tipo = 'normal';

    if (tipos.isNotEmpty) {
      final Map<String, dynamic> tipoItem = tipos.first as Map<String, dynamic>;
      final Map<String, dynamic> tipoDatos =
          tipoItem['type'] as Map<String, dynamic>? ?? <String, dynamic>{};

      tipo = tipoDatos['name'] as String? ?? 'normal';
    }

    final int id = datos['id'] as int? ?? 0;
    final String nombre = datos['name'] as String? ?? valorBusqueda;

    return PokemonCarta(
      id: id,
      nombre: _capitalizar(nombre),
      tipo: _capitalizar(tipo),
      imagenUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
      hp: obtenerStat('hp'),
      ataque: obtenerStat('attack'),
      defensa: obtenerStat('defense'),
      velocidad: obtenerStat('speed'),
    );
  }

  Future<RelacionesDanioTipo> obtenerRelacionesDanioTipo(String tipo) async {
    final String tipoNormalizado = tipo.trim().toLowerCase();
    if (tipoNormalizado.isEmpty) {
      throw Exception('Debes ingresar un tipo de Pokemon valido.');
    }

    final Uri url = Uri.parse('${obtenerUrlTipos()}/$tipoNormalizado');
    final http.Response respuesta = await http.get(url);
    if (respuesta.statusCode != 200) {
      throw Exception('No se pudo obtener el tipo solicitado.');
    }

    final Map<String, dynamic> datos =
        json.decode(respuesta.body) as Map<String, dynamic>;
    return ModeloRelacionesDanioTipo.fromJson(datos).aEntidad();
  }

  Future<NodoArbolPokemon> obtenerArbolEvolutivo(String nombreOId) async {
    final String pokemonBuscado = nombreOId.trim().toLowerCase();
    if (pokemonBuscado.isEmpty) {
      throw Exception('Debes ingresar un Pokemon valido.');
    }

    final Uri urlEspecie = Uri.parse(
      '${obtenerUrlPokemonSpecies()}/$pokemonBuscado',
    );
    final http.Response respuestaEspecie = await http.get(urlEspecie);

    if (respuestaEspecie.statusCode != 200) {
      throw Exception('No se pudo obtener la especie del Pokemon solicitado.');
    }

    final Map<String, dynamic> datosEspecie =
        json.decode(respuestaEspecie.body) as Map<String, dynamic>;
    final String? urlCadenaEvolutiva =
        (datosEspecie['evolution_chain'] as Map<String, dynamic>?)?['url']
            as String?;

    if (urlCadenaEvolutiva == null || urlCadenaEvolutiva.isEmpty) {
      throw Exception('La especie no contiene una cadena evolutiva valida.');
    }

    final http.Response respuestaCadena = await http.get(
      Uri.parse(urlCadenaEvolutiva),
    );
    if (respuestaCadena.statusCode != 200) {
      throw Exception('No se pudo obtener la cadena evolutiva.');
    }

    final Map<String, dynamic> datosCadena =
        json.decode(respuestaCadena.body) as Map<String, dynamic>;
    final Map<String, dynamic>? cadenaRaiz =
        datosCadena['chain'] as Map<String, dynamic>?;

    if (cadenaRaiz == null) {
      throw Exception('La cadena evolutiva no contiene datos.');
    }

    return _construirNodoEvolutivo(cadenaRaiz);
  }

  NodoArbolPokemon _construirNodoEvolutivo(Map<String, dynamic> cadenaNodo) {
    final Map<String, dynamic> especie =
        cadenaNodo['species'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final String nombre = (especie['name'] as String? ?? '').toLowerCase();
    final String url = especie['url'] as String? ?? '';

    final List<dynamic> evoluciones =
        cadenaNodo['evolves_to'] as List<dynamic>? ?? <dynamic>[];
    final List<NodoArbolPokemon> hijos = evoluciones
        .whereType<Map<String, dynamic>>()
        .map(_construirNodoEvolutivo)
        .toList();

    return NodoArbolPokemon(
      pokemon: Pokemon(nombre: nombre, url: url),
      hijos: hijos,
    );
  }

  String _capitalizar(String texto) {
    if (texto.isEmpty) {
      return texto;
    }

    return '${texto[0].toUpperCase()}${texto.substring(1)}';
  }
}
