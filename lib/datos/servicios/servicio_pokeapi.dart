import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proyecto_final_progra3/datos/modelos/modelo_pokemon.dart';
import 'package:proyecto_final_progra3/nucleo/configuracion/configuracion_api.dart';
import 'package:proyecto_final_progra3/nucleo/constantes/api_constantes.dart';

class ServicioPokeapi {
  String obtenerUrlPokemon() {
    return '${ConfiguracionApi.urlBase}${ApiConstantes.endpointPokemon}';
  }

  Future<List<Pokemon>> obtenerPokemones() async {
    final Uri url = Uri.parse('${obtenerUrlPokemon()}?limit=20&offset=0');
    final http.Response respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final Map<String, dynamic> datos = json.decode(respuesta.body);
      final List<dynamic> resultados = datos['results'] ?? <dynamic>[];

      return resultados
          .map((dynamic item) => Pokemon.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al obtener los pokemones desde la API');
    }
  }
}
