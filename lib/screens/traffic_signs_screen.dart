import 'package:flutter/material.dart';

class TrafficSignsScreen extends StatelessWidget {
  const TrafficSignsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Дорожні знаки")),
      body: const Center(
        child: Text(
          "Каталог дорожніх знаків буде додано пізніше.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
