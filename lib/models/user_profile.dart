import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 10)
class UserProfile extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  int xp;

  @HiveField(2)
  int level;

  @HiveField(3)
  int testsPassed;

  @HiveField(4)
  int correctAnswers;

  @HiveField(5)
  int wrongAnswers;

  UserProfile({
    required this.username,
    this.xp = 0,
    this.level = 1,
    this.testsPassed = 0,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
  });

  /// Автоматичний підрахунок рівня
  void recalcLevel() {
    level = (xp ~/ 100) + 1;
  }

  /// Додавання досвіду
  void addXP(int amount) {
    xp += amount;
    recalcLevel();
  }
}
