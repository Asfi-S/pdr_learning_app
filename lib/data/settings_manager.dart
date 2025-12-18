import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static const _airaKey = 'show_aira';

  static Future<bool> isAiraEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_airaKey) ?? true;
  }

  static Future<void> setAiraEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_airaKey, value);
  }
}
