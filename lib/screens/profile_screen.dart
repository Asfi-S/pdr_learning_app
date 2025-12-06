import 'package:flutter/material.dart';
import '../data/user_profile_manager.dart';
import '../data/achievements_manager.dart';

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

        String avatar = "assets/images/aira_happy.png";
        if (p.level >= 5) avatar = "assets/images/aira_sad.png";
        if (p.level >= 10) avatar = "assets/images/aira_angry.png";

        return Scaffold(
          appBar: AppBar(title: const Text("Профіль користувача")),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Center(
                    child: Column(
                      children: [
                        Image.asset(avatar, width: 120),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              p.username,
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(width: 6),

                            GestureDetector(
                              onTap: () async {
                                await Navigator.pushNamed(context, "/set_name");
                                (context as Element).reassemble(); // оновлення
                              },
                              child: const Icon(Icons.edit, size: 22),
                            ),
                          ],
                        ),

                        Text("Рівень ${p.level}", style: theme.textTheme.bodyLarge),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),

                  ListTile(
                    leading: Icon(Icons.emoji_events, color: theme.colorScheme.primary),
                    title: const Text("XP"),
                    trailing: Text("${p.xp} XP"),
                  ),

                  ListTile(
                    leading: const Icon(Icons.task_alt, color: Colors.green),
                    title: const Text("Правильних відповідей"),
                    trailing: Text("${p.correctAnswers}"),
                  ),

                  ListTile(
                    leading: const Icon(Icons.close, color: Colors.red),
                    title: const Text("Неправильних відповідей"),
                    trailing: Text("${p.wrongAnswers}"),
                  ),

                  ListTile(
                    leading: const Icon(Icons.quiz, color: Colors.blue),
                    title: const Text("Пройдено тестів"),
                    trailing: Text("${p.testsPassed}"),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),

                  Text(
                    "Досягнення",
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...AchievementsManager.all.map((a) {
                    final unlocked = p.unlockedAchievements.contains(a.id);
                    return _achievementTile(
                      theme,
                      title: a.title,
                      desc: a.description,
                      icon: a.icon,
                      unlocked: unlocked,
                    );
                  }).toList(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _achievementTile(
      ThemeData theme, {
        required String title,
        required String desc,
        required String icon,
        required bool unlocked,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: unlocked
            ? theme.colorScheme.primary.withOpacity(0.15)
            : theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: unlocked
              ? theme.colorScheme.primary
              : Colors.grey.withOpacity(0.3),
          width: 1.6,
        ),
      ),
      child: Row(
        children: [
          Image.asset(icon, width: 42),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(desc, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),

          Icon(
            unlocked ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
            size: 28,
            color: unlocked ? theme.colorScheme.primary : Colors.grey,
          ),
        ],
      ),
    );
  }
}
