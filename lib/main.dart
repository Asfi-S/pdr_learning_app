import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/pdr_theme.dart';

// Screens
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/history_screen.dart';
import 'screens/theory_screen.dart';
import 'screens/test_menu_screen.dart';
import 'screens/traffic_signs_screen.dart';
import 'screens/sections_details_screen.dart';

// Models
import 'models/section_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PDRApp());
}

class PDRApp extends StatefulWidget {
  const PDRApp({super.key});

  @override
  State<PDRApp> createState() => _PDRAppState();
}

class _PDRAppState extends State<PDRApp> {
  bool _isDark = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  /// 🔥 Завантаження теми із SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool("isDark") ?? false;
    setState(() {
      _isDark = saved;
      _loaded = true;
    });
  }

  /// 🔥 Зміна теми + збереження
  void toggleTheme() async {
    final newValue = !_isDark;
    setState(() => _isDark = newValue);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDark", newValue);
  }

  @override
  Widget build(BuildContext context) {
    // Показуємо splash поки тема не прочиталась
    if (!_loaded) {
      return MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      title: "Вивчення ПДР",
      debugShowCheckedModeBanner: false,

      // Теми
      theme: PdrTheme.light,
      darkTheme: PdrTheme.dark,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,

      // Головний екран
      home: const HomeScreen(),

      // Маршрути
      routes: {
        "/settings": (_) => SettingsScreen(
          toggleTheme: toggleTheme,
          isDark: _isDark,
        ),
        "/history": (_) => const HistoryScreen(),
        "/theory": (_) => const TheoryScreen(),
        "/test": (_) => const TestMenuScreen(),
        "/signs": (_) => const TrafficSignsScreen(),
      },

      // Динамічні сторінки
      onGenerateRoute: (settings) {
        if (settings.name == "/section_details") {
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
