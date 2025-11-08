import 'dart:convert';
import 'db_helper.dart';

Future<void> seedDatabase() async {
  final db = DBHelper();

  final existingSections = await db.getSections();
  if (existingSections.isNotEmpty) {
    print('⚠️ Дані вже існують — пропускаємо seed.');
    return;
  }

  final sections = [
    {
      'title': 'Розділ 1. Загальні положення',
      'description': 'Основні терміни, визначення і принципи дорожнього руху.',
      'content': [
        {
          'number': '1.1',
          'text':
          'Ці Правила відповідно до Закону України «Про дорожній рух» встановлюють єдиний порядок дорожнього руху на всій території України.'
        },
        {
          'number': '1.2',
          'text':
          'В Україні встановлено правосторонній рух транспортних засобів.'
        },
        {
          'number': '1.3',
          'text':
          'Учасники дорожнього руху зобов’язані знати і неухильно виконувати вимоги цих Правил.'
        },
        {
          'number': '1.4',
          'text':
          'Кожен учасник дорожнього руху має право розраховувати на те, що інші учасники виконують ці Правила.'
        },
      ],
    },
  ];

  for (var section in sections) {
    final fixedSection = Map<String, dynamic>.from(section);
    fixedSection['content'] = jsonEncode(section['content']);
    await db.insertSection(fixedSection);
  }

  print('✅ База заповнена правильно!');
}
