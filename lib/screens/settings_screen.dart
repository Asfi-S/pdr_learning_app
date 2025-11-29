import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const SettingsScreen({
    super.key,
    required this.toggleTheme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Налаштування"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ------------------------------
          // 🔥 Перемикач теми
          // ------------------------------

          Card(
            child: SwitchListTile(
              title: const Text("Темний режим"),
              subtitle: const Text("Перемкнути тему застосунку"),
              value: isDark,
              onChanged: (_) => toggleTheme(),
              secondary: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: theme.colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ------------------------------
          // ℹ Інформація про програму
          // ------------------------------

          Card(
            child: ListTile(
              leading: Icon(Icons.info_outline, color: theme.colorScheme.primary),
              title: const Text("Про програму"),
              subtitle: const Text("Версія 1.0.0"),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationIcon: Image.asset(
                    "assets/images/pdr_logo.png",
                    width: 60,
                  ),
                  applicationName: "Вивчення ПДР",
                  applicationVersion: "1.0.0",
                  children: const [
                    Text("Застосунок для вивчення Правил дорожнього руху."),
                    Text("Розроблено Asfinian Studio © 2025"),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // ------------------------------
          // 📊 ІСТОРІЯ ПРОХОДЖЕНЬ (ТЕПЕР РЕАЛЬНА)
          // ------------------------------

          Card(
            child: ListTile(
              leading: Icon(Icons.history, color: theme.colorScheme.primary),
              title: const Text("Історія проходжень"),
              subtitle: const Text("Переглянути результати тестів"),
              onTap: () {
                Navigator.pushNamed(context, "/history");
              },
            ),
          ),

          const SizedBox(height: 40),

          Center(
            child: Text(
              "© 2025 Asfinian Studio",
              style: theme.textTheme.bodyMedium!.copyWith(
                fontSize: 12,
                color: theme.brightness == Brightness.dark
                    ? Colors.white38
                    : Colors.black38,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
