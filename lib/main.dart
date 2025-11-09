import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'data/seed_data.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    print('💾 Використовується sqflite_common_ffi');
  }

  final dbPath = join(await getDatabasesPath(), 'pdr_learning.db');
  await deleteDatabase(dbPath);
  print('🧹 Стара база видалена: $dbPath');

  await seedDatabase();

  final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

  runApp(MyApp(themeNotifier: themeNotifier));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeNotifier;
  const MyApp({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ПДР Навчання',
          themeMode: mode,
          theme: ThemeData(
            colorSchemeSeed: Colors.redAccent,
            brightness: Brightness.light,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorSchemeSeed: Colors.redAccent,
            brightness: Brightness.dark,
            useMaterial3: true,
          ),
          home: HomeScreen(themeNotifier: themeNotifier),
        );
      },
    );
  }
}
