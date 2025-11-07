import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PDRApp());
}

class PDRApp extends StatelessWidget {
  const PDRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Вивчення ПДР',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
