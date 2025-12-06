import 'package:shared_preferences/shared_preferences.dart';

class UserNameManager {
  static const _key = "username";

  static Future<bool> hasName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) != null;
  }

  static Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, name);
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}
