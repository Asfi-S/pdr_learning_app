import 'package:flutter/material.dart';
import '../data/user_profile_manager.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder(
      future: UserProfileManager.loadProfile(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final p = snapshot.data!;

        // Вибір аватарки за рівнем
        String avatar = "assets/images/aira_happy.png";
        if (p.level >= 5) avatar = "assets/images/aira_sad.png";
        if (p.level >= 10) avatar = "assets/images/aira_angry.png";

        return Scaffold(
          appBar: AppBar(title: const Text("Профіль користувача")),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                // АВАТАР + ІМ'Я + РІВЕНЬ
                Center(
                  child: Column(
                    children: [
                      Image.asset(avatar, width: 120),
                      const SizedBox(height: 8),

                      Text(
                        p.username,
                        style: theme.textTheme.titleLarge,
                      ),

                      Text(
                        "Рівень ${p.level}",
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(),

                // XP
                ListTile(
                  leading: Icon(Icons.emoji_events, color: theme.colorScheme.primary),
                  title: const Text("Набрано XP"),
                  trailing: Text("${p.xp} XP"),
                ),

                // Правильні
                ListTile(
                  leading: const Icon(Icons.task_alt, color: Colors.green),
                  title: const Text("Правильних відповідей"),
                  trailing: Text("${p.correctAnswers}"),
                ),

                // Неправильні
                ListTile(
                  leading: const Icon(Icons.close, color: Colors.red),
                  title: const Text("Неправильних відповідей"),
                  trailing: Text("${p.wrongAnswers}"),
                ),

                // Пройдено тестів
                ListTile(
                  leading: const Icon(Icons.quiz, color: Colors.blue),
                  title: const Text("Пройдено тестів"),
                  trailing: Text("${p.testsPassed}"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
