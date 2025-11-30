import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/test_question_model.dart';

class PdrTestsLoader {
  static const String _testsPath = 'assets/pdr/tests.json';

  static Future<List<TestQuestionModel>> loadAll() async {
    final raw = await rootBundle.loadString(_testsPath);
    final List list = json.decode(raw) as List;

    return list.map((e) => TestQuestionModel.fromJson(e)).toList();
  }

  static Future<List<TestQuestionModel>> loadBySection(String sectionId) async {
    final all = await loadAll();
    return all.where((e) => e.sectionId == sectionId).toList();
  }
}
