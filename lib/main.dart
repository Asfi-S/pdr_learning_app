import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'theme/pdr_theme.dart';

import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/history_screen.dart';
import 'screens/theory_screen.dart';
import 'screens/test_menu_screen.dart';
import 'screens/traffic_signs_screen.dart';
import 'screens/sections_details_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/set_name_screen.dart';

import 'models/section_model.dart';
import 'models/user_profile.dart';

import 'data/user_name_manager.dart';
import 'data/user_profile_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserProfileAdapter());
  await Hive.openBox<UserProfile>("user_profile");

  final hasName = await UserNameManager.hasName();

  runApp(PDRApp(firstStart: !hasName));
}

class PDRApp extends StatefulWidget {
  final bool firstStart;
  const PDRApp({super.key, required this.firstStart});

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

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool("isDark") ?? false;
    _loaded = true;
    setState(() {});
  }

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final newValue = !_isDark;
    await prefs.setBool("isDark", newValue);
    setState(() => _isDark = newValue);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: "ПДР України 2025",
      debugShowCheckedModeBanner: false,

      theme: PdrTheme.light,
      darkTheme: PdrTheme.dark,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,

      home: widget.firstStart ? const SetNameScreen() : const HomeScreen(),

      routes: {
        "/settings": (_) => SettingsScreen(toggleTheme: toggleTheme, isDark: _isDark),
        "/history": (_) => const HistoryScreen(),
        "/theory": (_) => const TheoryScreen(),
        "/test": (_) => const TestMenuScreen(),
        "/signs": (_) => const TrafficSignsScreen(),
        "/profile": (_) => const ProfileScreen(),
      },

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
