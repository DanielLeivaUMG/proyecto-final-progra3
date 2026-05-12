import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/nucleo/tema/colores_app.dart';

class TemaApp {
  TemaApp._();

  static final ThemeData temaClaro = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: ColoresApp.primario,
      onPrimary: Colors.white,
      secondary: ColoresApp.secundario,
      onSecondary: Colors.white,
      tertiary: ColoresApp.acento,
      onTertiary: ColoresApp.textoPrincipal,
      surface: ColoresApp.tarjeta,
      onSurface: ColoresApp.textoPrincipal,
      error: Colors.red.shade700,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: ColoresApp.fondo,
    appBarTheme: const AppBarTheme(
      backgroundColor: ColoresApp.primario,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: ColoresApp.tarjeta,
      elevation: 1.5,
      shadowColor: ColoresApp.textoPrincipal.withValues(alpha: 0.08),
      surfaceTintColor: ColoresApp.tarjeta,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: ColoresApp.secundario.withValues(alpha: 0.12)),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColoresApp.primario,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColoresApp.secundario,
        minimumSize: const Size.fromHeight(52),
        side: BorderSide(
          color: ColoresApp.secundario.withValues(alpha: 0.45),
          width: 1.2,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColoresApp.acento,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ColoresApp.acento,
      foregroundColor: ColoresApp.textoPrincipal,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: ColoresApp.secundario.withValues(alpha: 0.08),
      selectedColor: ColoresApp.acento.withValues(alpha: 0.3),
      disabledColor: ColoresApp.secundario.withValues(alpha: 0.06),
      deleteIconColor: ColoresApp.textoSecundario,
      side: BorderSide(color: ColoresApp.secundario.withValues(alpha: 0.18)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      labelStyle: const TextStyle(
        color: ColoresApp.textoPrincipal,
        fontWeight: FontWeight.w600,
      ),
      secondaryLabelStyle: const TextStyle(
        color: ColoresApp.textoPrincipal,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      brightness: Brightness.light,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColoresApp.tarjeta,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: ColoresApp.secundario.withValues(alpha: 0.25),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: ColoresApp.secundario.withValues(alpha: 0.25),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: ColoresApp.primario, width: 1.5),
      ),
      labelStyle: const TextStyle(color: ColoresApp.textoSecundario),
      hintStyle: TextStyle(
        color: ColoresApp.textoSecundario.withValues(alpha: 0.85),
      ),
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
      bodyMedium: TextStyle(color: ColoresApp.textoSecundario),
    ),
  );
}
