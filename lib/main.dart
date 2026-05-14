import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/pantalla_inicio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PokéPlanner',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const PantallaInicio(),
    );
  }
}
