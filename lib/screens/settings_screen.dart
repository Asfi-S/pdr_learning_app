import 'package:flutter/material.dart';
import '../data/settings_manager.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const SettingsScreen({
    super.key,
    required this.toggleTheme,
    required this.isDark,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool soundsEnabled = true;
  bool vibrationEnabled = true;
  bool confirmExamExit = true;
  bool showAira = true;
  bool animationsEnabled = true;

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
          Card(
            child: SwitchListTile(
              title: const Text("Темний режим"),
              subtitle: const Text("Перемкнути тему застосунку"),
              value: widget.isDark,
              onChanged: (_) => widget.toggleTheme(),
              secondary: Icon(
                widget.isDark ? Icons.dark_mode : Icons.light_mode,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Icon(Icons.language, color: theme.colorScheme.primary),
              title: const Text("Мова застосунку"),
              subtitle: const Text("Українська"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Зміна мови буде додана пізніше"),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: SwitchListTile(
              title: const Text("Звуки"),
              subtitle: const Text("Звукові ефекти у тестах"),
              value: soundsEnabled,
              onChanged: (v) => setState(() => soundsEnabled = v),
              secondary:
              Icon(Icons.volume_up, color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: SwitchListTile(
              title: const Text("Вібрація"),
              subtitle: const Text("Вібрація при відповіді"),
              value: vibrationEnabled,
              onChanged: (v) => setState(() => vibrationEnabled = v),
              secondary:
              Icon(Icons.vibration, color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: SwitchListTile(
              title: const Text("Підтвердження виходу з екзамену"),
              subtitle: const Text("Показувати попередження"),
              value: confirmExamExit,
              onChanged: (v) => setState(() => confirmExamExit = v),
              secondary: Icon(Icons.warning_amber,
                  color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<bool>(
            future: SettingsManager.isAiraEnabled(),
            builder: (context, snapshot) {
              final enabled = snapshot.data ?? true;

              return Card(
                child: SwitchListTile(
                  title: const Text("Айра"),
                  subtitle:
                  const Text("Показувати персонажа у тренуваннях"),
                  value: enabled,
                  onChanged: (v) async {
                    await SettingsManager.setAiraEnabled(v);
                    if (context.mounted) {
                      setState(() {});
                    }
                  },
                  secondary: Icon(
                    Icons.face_retouching_natural,
                    color: theme.colorScheme.primary,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Card(
            child: SwitchListTile(
              title: const Text("Анімації"),
              subtitle: const Text("Увімкнути анімації інтерфейсу"),
              value: animationsEnabled,
              onChanged: (v) => setState(() => animationsEnabled = v),
              secondary:
              Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading:
              const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: const Text("Очистити історію проходжень"),
              subtitle: const Text("Видалити всі результати тестів"),
              onTap: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Очистити історію?"),
                    content:
                    const Text("Цю дію неможливо скасувати."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Скасувати"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Очистити"),
                      ),
                    ],
                  ),
                );

                if (ok == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                      Text("Історію очищено (поки демо)"),
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading:
              Icon(Icons.info_outline, color: theme.colorScheme.primary),
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
                    Text(
                        "Застосунок для вивчення Правил дорожнього руху."),
                    Text("Розроблено Asfinian Studio™ © 2025"),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              "© 2025 Asfinian Studio™",
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
