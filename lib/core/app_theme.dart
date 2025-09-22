// lib/core/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- PALETA DE COLORES PARA EL TEMA OSCURO ---
  static const Color darkPrimaryColor = Color(0xFFFFEB3B); // Amarillo Eléctrico
  static const Color darkBackgroundColor = Color(0xFF121212); // Negro profundo
  static const Color darkCardColor = Color(0xFF1E1E1E);      // Gris muy oscuro para tarjetas
  static const Color darkTextColor = Color(0xFFE0E0E0);       // Texto principal casi blanco
  static const Color darkSecondaryTextColor = Color(0xFFBDBDBD); // Texto secundario gris claro

  // --- TEMA OSCURO COMPLETO ---
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark, // Importante para que los widgets se adapten
    primaryColor: darkPrimaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    
    colorScheme: const ColorScheme.dark(
      primary: darkPrimaryColor,
      secondary: darkPrimaryColor, // Usamos el mismo para acentos
      background: darkBackgroundColor,
      surface: darkCardColor,
      onPrimary: Colors.black, // Texto sobre elementos primarios (botones amarillos)
      onBackground: darkTextColor,
      onSurface: darkTextColor,
    ),
    
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      headlineMedium: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      titleMedium: TextStyle(color: darkTextColor),
      bodyLarge: TextStyle(color: darkSecondaryTextColor),
      bodyMedium: TextStyle(color: darkSecondaryTextColor),
    ),
    
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackgroundColor,
      elevation: 0,
    ),

    // Estilo para los cards
    cardTheme: CardTheme(
      color: darkCardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Estilo para los botones
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimaryColor,
        foregroundColor: Colors.black, // Texto negro para contraste en botón amarillo
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    // Estilo para la barra de navegación inferior
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkCardColor,
      selectedItemColor: darkPrimaryColor,
      unselectedItemColor: darkSecondaryTextColor,
      showUnselectedLabels: false,
      showSelectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),

    // Estilo para los campos de texto
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      prefixIconColor: darkSecondaryTextColor,
    ),
  );
}