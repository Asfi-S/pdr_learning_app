import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/test_question_model.dart';

class PdrTestsLoader {
  static Future<List<TestQuestionModel>> loadTests() async {
    final jsonString = await rootBundle.loadString('assets/pdr/tests.json');
    final List data = json.decode(jsonString);

    return data.map((e) => TestQuestionModel.fromJson(e)).toList();
  }
}
