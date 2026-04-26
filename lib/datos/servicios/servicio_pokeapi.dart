import 'package:proyecto_final_progra3/nucleo/constantes/api_constantes.dart';

class ServicioPokeapi {
  String obtenerUrlPokemon() {
    return '${ApiConstantes.urlBase}${ApiConstantes.endpointPokemon}';
  }
}
