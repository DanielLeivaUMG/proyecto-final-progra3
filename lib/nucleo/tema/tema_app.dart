import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/nucleo/tema/colores_app.dart';

class TemaApp {
  TemaApp._();

  static final ThemeData temaClaro = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: ColoresApp.fondo,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: ColoresApp.primario,
      onPrimary: Colors.white,
      secondary: ColoresApp.secundario,
      onSecondary: Colors.white,
      error: Colors.red.shade700,
      onError: Colors.white,
      surface: ColoresApp.tarjeta,
      onSurface: ColoresApp.textoPrincipal,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: ColoresApp.primario,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: ColoresApp.tarjeta,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColoresApp.primario,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColoresApp.tarjeta,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: ColoresApp.secundario.withValues(alpha: 0.25)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: ColoresApp.secundario.withValues(alpha: 0.25)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: ColoresApp.primario, width: 1.5),
      ),
      labelStyle: const TextStyle(color: ColoresApp.textoSecundario),
      hintStyle: TextStyle(color: ColoresApp.textoSecundario.withValues(alpha: 0.85)),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        color: ColoresApp.textoPrincipal,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: ColoresApp.textoPrincipal,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(
        color: ColoresApp.textoSecundario,
      ),
    ),
  );
}
