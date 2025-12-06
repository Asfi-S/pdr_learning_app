import 'package:flutter/material.dart';

import '../models/achievement.dart';
import '../models/user_profile.dart';
import 'user_profile_manager.dart';
import '../utils/show_achievement_popup.dart';

class AchievementsManager {
  static final List<Achievement> all = [
    Achievement(
      id: "first_test",
      title: "Перший тест!",
      description: "Пройди свій перший тест.",
      icon: "assets/images/ach_first.png",
    ),
    Achievement(
      id: "correct_10",
      title: "Початківець",
      description: "10 правильних відповідей.",
      icon: "assets/images/ach_10.png",
    ),
    Achievement(
      id: "xp_100",
      title: "Новий рівень!",
      description: "Отримай 100 XP.",
      icon: "assets/images/ach_xp100.png",
    ),
    Achievement(
      id: "xp_120",
      title: "Досвідчений!",
      description: "Отримай 120 XP.",
      icon: "assets/images/ach_xp100.png",
    ),
  ];

  static Future<void> check(UserProfile profile, BuildContext context) async {
    for (final achievement in all) {
      final alreadyUnlocked =
      profile.unlockedAchievements.contains(achievement.id);

      if (alreadyUnlocked) continue;

      bool shouldUnlock = false;

      switch (achievement.id) {
        case "first_test":
          shouldUnlock = profile.testsPassed >= 1;
          break;

        case "correct_10":
          shouldUnlock = profile.correctAnswers >= 10;
          break;

        case "xp_100":
          shouldUnlock = profile.xp >= 100;
          break;

        case "xp_120":
          shouldUnlock = profile.xp >= 120;
          break;
      }

      if (shouldUnlock) {
        profile.unlockedAchievements.add(achievement.id);

        await showAchievementPopup(
          context,
          title: achievement.title,
          description: achievement.description,
          icon: achievement.icon,
        );

        await Future.delayed(const Duration(milliseconds: 150));
      }
    }

    await UserProfileManager.saveProfile(profile);
  }
}