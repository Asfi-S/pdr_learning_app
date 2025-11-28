import 'dart:math';
import '../models/test_question_model.dart';

class TestUtils {
  /// Перемішати список питань (нічого більше не робить)
  static List<TestQuestionModel> randomizeQuestions(
      List<TestQuestionModel> list,
      ) {
    final rng = Random();
    final items = List<TestQuestionModel>.from(list);
    items.shuffle(rng);
    return items;
  }

  /// Перемішати відповіді в одному питанні
  static TestQuestionModel randomizeAnswers(TestQuestionModel q) {
    final rng = Random();
    final answers = List<String>.from(q.answers);
    final correctIndex = q.correctIndex;

    final correctAnswer = answers[correctIndex];
    answers.shuffle(rng);
    final newIndex = answers.indexOf(correctAnswer);

    return TestQuestionModel(
      id: q.id,
      sectionId: q.sectionId,
      question: q.question,
      answers: answers,
      correctIndex: newIndex,
      imagePath: q.imagePath,
    );
  }
}
