import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/pantalla_lista_pokemon.dart';

class AplicacionPrincipal extends StatelessWidget {
  const AplicacionPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex Estructuras',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
        ),
      ),
      home: const PantallaListaPokemon(),
    );
  }
}
