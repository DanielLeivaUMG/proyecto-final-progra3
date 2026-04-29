import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/nucleo/tema/tema_app.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/pantalla_inicio.dart';

class AplicacionPrincipal extends StatelessWidget {
  const AplicacionPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokéPlanner',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.temaClaro,
      home: const PantallaInicio(),
    );
  }
}
