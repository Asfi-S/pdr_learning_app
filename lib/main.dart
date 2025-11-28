import 'package:flutter/material.dart';
import 'theme/pdr_theme.dart';

// Screens
import 'screens/home_screen.dart';
import 'screens/theory_screen.dart';
import 'screens/test_menu_screen.dart';   // 🔥 НОВИЙ
import 'screens/traffic_signs_screen.dart';
import 'screens/sections_details_screen.dart';

// Models
import 'models/section_model.dart';

void main() {
  runApp(const PDRApp());
}

class PDRApp extends StatefulWidget {
  const PDRApp({super.key});

  @override
  State<PDRApp> createState() => _PDRAppState();
}

class _PDRAppState extends State<PDRApp> {
  bool _isDark = false;

  void toggleTheme() {
    setState(() => _isDark = !_isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Вивчення ПДР',
      debugShowCheckedModeBanner: false,

      // Теми
      theme: PdrTheme.light,
      darkTheme: PdrTheme.dark,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,

      initialRoute: '/',


      routes: {
        '/': (_) => HomeScreen(
          toggleTheme: toggleTheme,
          isDark: _isDark,
        ),

        '/theory': (_) => const TheoryScreen(),

        // 🔥 Тепер це меню тестування!
        '/test': (_) => const TestMenuScreen(),

        '/signs': (_) => const TrafficSignsScreen(),
      },

      // екрани з аргументами
      onGenerateRoute: (settings) {
        if (settings.name == '/section_details') {
          final args = settings.arguments;

          if (args is SectionModel) {
            return MaterialPageRoute(
              builder: (_) => SectionDetailsScreen(section: args),
            );
          }
        }

        return null;
      },
    );
  }
}
