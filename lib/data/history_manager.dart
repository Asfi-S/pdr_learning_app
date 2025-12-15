import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryItem {
  final String title;
  final int total;
  final int right;
  final int percent;
  final DateTime date;

  HistoryItem({
    required this.title,
    required this.total,
    required this.right,
    required this.percent,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "total": total,
    "right": right,
    "percent": percent,
    "date": date.toIso8601String(),
  };

  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
    title: json["title"],
    total: json["total"],
    right: json["right"],
    percent: json["percent"],
    date: DateTime.parse(json["date"]),
  );
}

class HistoryManager {
  static const _key = "test_history";

  static Future<List<HistoryItem>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map((e) => HistoryItem.fromJson(jsonDecode(e)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // ----------------------------------------------------
  // 🆕 ОСТАННІЙ РЕЗУЛЬТАТ
  // ----------------------------------------------------
  static Future<HistoryItem?> last() async {
    final list = await load();
    if (list.isEmpty) return null;
    return list.first; // бо список вже відсортований по даті
  }

  static Future<void> add(HistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.add(jsonEncode(item.toJson()));
    await prefs.setStringList(_key, list);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
