import 'package:flutter/material.dart';

class PdrTheme {
  // 🌞 СВІТЛА ТЕМА
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: const Color(0xFFFFF5F5),

    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: const Color(0xFFFF6E6E),
      primary: const Color(0xFFFF6E6E),
      secondary: const Color(0xFFFF9E9E),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: const CardThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
    ),

    listTileTheme: const ListTileThemeData(
      iconColor: Colors.black87,
      textColor: Colors.black87,
      tileColor: Colors.white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF7A7A),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        elevation: 4,
        shadowColor: Colors.black26,
      ),
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
      bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
      titleLarge: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    ),
  );

  // 🌙 ТЕМНА ТЕМА
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF0E0E1A),
    canvasColor: const Color(0xFF141428),

    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: const Color(0xFFFF6E6E),
      primary: const Color(0xFFFF6E6E),
      secondary: const Color(0xFFFF8A80),
      surface: const Color(0xFF1C1C2E),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0B0B13),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: const CardThemeData(
      color: Color(0xFF1A1A28),
      surfaceTintColor: Colors.transparent,
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
    ),

    listTileTheme: const ListTileThemeData(
      iconColor: Colors.white70,
      textColor: Colors.white70,
      tileColor: Color(0xFF1A1A28),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF27273A),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        elevation: 6,
        shadowColor: Colors.black87,
      ),
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white70),
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      titleLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    ),
  );
}
