import 'package:flutter/material.dart';

class PdrTheme {
  // 🌞 СВІТЛА ТЕМА
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: const Color(0xFFFFF5F5),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFF6E6E),
      secondary: Color(0xFFFF9E9E),
      surface: Colors.white,
      onSurface: Colors.black87,
      onPrimary: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),


    // КАРТОЧКИ
    cardColor: Colors.white,
    cardTheme: CardThemeData(
      color: Colors.white,
      shadowColor: Colors.black12,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
    ),

    // КНОПКИ
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFF7A7A),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        elevation: 3,
      ),
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
      bodyLarge: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
  );

  // 🌙 ТЕМНА ТЕМА
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF0E0E1A),
    canvasColor: const Color(0xFF141428),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFF6E6E),
      secondary: Color(0xFFFF8A80),
      surface: Color(0xFF1C1C2E),
      onSurface: Colors.white70,
      onPrimary: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0B0B13),
      foregroundColor: Colors.white,
      elevation: 0,
    ),


    // КАРТОЧКИ
    cardColor: Color(0xFF1A1A28),
    cardTheme: CardThemeData(
      color: Color(0xFF1A1A28),
      shadowColor: Colors.black54,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
    ),

    // КНОПКИ
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF27273A),
        foregroundColor: Colors.white,
        shadowColor: Colors.black54,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        elevation: 6,
      ),
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white70),
      bodyLarge: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}
