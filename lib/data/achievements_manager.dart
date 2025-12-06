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
      id: "correct_50",
      title: "Таланливий розум",
      description: "50 правильних відповідей.",
      icon: "assets/images/ach_50.png",
    ),
    Achievement(
      id: "correct_100",
      title: "Майстер теорії",
      description: "100 правильних відповідей!",
      icon: "assets/images/ach_100.png",
    ),
    Achievement(
      id: "tests_5",
      title: "Впевнений учень",
      description: "Пройди 5 тестів.",
      icon: "assets/images/ach_5.png",
    ),
    Achievement(
      id: "tests_20",
      title: "Серійний екзаменатор",
      description: "20 пройдених тестів!",
      icon: "assets/images/ach_20.png",
    ),
    Achievement(
      id: "xp_300",
      title: "XP Монстр",
      description: "Накопич 300 XP.",
      icon: "assets/images/ach_300.png",
    ),
    Achievement(
      id: "xp_500",
      title: "Легенда ПДР",
      description: "Досягни 500 XP. Це сила!",
      icon: "assets/images/ach_500.png",
    ),
    Achievement(
      id: "wrong_30",
      title: "Помилятись — теж шлях",
      description: "30 неправильних відповідей. Головне — навчання!",
      icon: "assets/images/ach_wrong.png",
    ),
    Achievement(
      id: "perfect_test",
      title: "Ідеальний проїзд",
      description: "Пройди тест без помилок.",
      icon: "assets/images/ach_clear.png",
    ),
  ];

  static Future<void> check(UserProfile profile, BuildContext context) async {
    for (final achievement in all) {
      final alreadyUnlocked = profile.unlockedAchievements.contains(achievement.id);
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

        case "correct_50":
          shouldUnlock = profile.correctAnswers >= 50;
          break;

        case "correct_100":
          shouldUnlock = profile.correctAnswers >= 100;
          break;

        case "tests_5":
          shouldUnlock = profile.testsPassed >= 5;
          break;

        case "tests_20":
          shouldUnlock = profile.testsPassed >= 20;
          break;

        case "xp_300":
          shouldUnlock = profile.xp >= 300;
          break;

        case "xp_500":
          shouldUnlock = profile.xp >= 500;
          break;

        case "wrong_30":
          shouldUnlock = profile.wrongAnswers >= 30;
          break;

        case "perfect_test":
          shouldUnlock = profile.wrongAnswers == 0 && profile.testsPassed >= 1;
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
