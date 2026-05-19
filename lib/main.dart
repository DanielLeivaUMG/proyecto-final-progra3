import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/aplicacion/aplicacion_principal.dart';
import 'package:proyecto_final_progra3/nucleo/configuracion/configuracion_api.dart';

void main() {
  ConfiguracionApi.validar();
  runApp(const AplicacionPrincipal());
}
