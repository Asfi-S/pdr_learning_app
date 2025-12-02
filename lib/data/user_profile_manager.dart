import 'package:hive/hive.dart';
import '../models/user_profile.dart';

class UserProfileManager {
  static const String boxName = "user_profile_box";

  /// Завантаження профілю
  static Future<UserProfile> loadProfile() async {
    final box = await Hive.openBox<UserProfile>(boxName);

    if (box.isEmpty) {
      final profile = UserProfile(username: "Користувач");
      await box.put(0, profile);
      return profile;
    }

    return box.get(0)!;
  }

  /// Збереження профілю
  static Future<void> saveProfile(UserProfile profile) async {
    final box = await Hive.openBox<UserProfile>(boxName);
    await box.put(0, profile);
  }

  /// Додавання досвіду
  static Future<void> addXP(int amount) async {
    final p = await loadProfile();
    p.addXP(amount);
    await saveProfile(p);
  }

  /// Оновлення статистики відповідей
  static Future<void> updateStats({required bool correct}) async {
    final profile = await loadProfile();

    if (correct) {
      profile.correctAnswers++;
      profile.addXP(5);
    } else {
      profile.wrongAnswers++;
    }

    profile.recalcLevel();
    await saveProfile(profile);
  }

  /// Пройдено тест
  static Future<void> addTestPassed() async {
    final profile = await loadProfile();
    profile.testsPassed++;
    await saveProfile(profile);
  }
}
