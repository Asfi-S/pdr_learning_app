import 'dart:math';
import '../models/test_question_model.dart';

class TestUtils {
  /// Перемішує питання. Якщо examMode=true — повертає 20 випадкових.
  static List<TestQuestionModel> randomizeQuestions(
      List<TestQuestionModel> list, {
        bool examMode = false,
      }) {
    final rng = Random();

    // Створюємо копію, щоб не псувати оригінал
    final items = List<TestQuestionModel>.from(list);

    // Перемішуємо
    items.shuffle(rng);

    // Якщо режим екзамену — беремо 20
    if (examMode) {
      return items.take(20).toList();
    }

    return items;
  }

  /// Перемішує відповіді, зберігаючи правильну
  static TestQuestionModel randomizeAnswers(TestQuestionModel q) {
    final rng = Random();

    final answers = List<String>.from(q.answers);
    final correctAnswer = answers[q.correctIndex];

    // Перемішуємо відповіді
    answers.shuffle(rng);

    // Знаходимо новий індекс правильної відповіді
    final newCorrectIndex = answers.indexOf(correctAnswer);

    // ПОВЕРТАЄМО ОНОВЛЕНУ МОДЕЛЬ
    return TestQuestionModel(
      id: q.id,                   // ← додано
      sectionId: q.sectionId,     // ← додано
      question: q.question,
      answers: answers,
      correctIndex: newCorrectIndex,
      imagePath: q.imagePath,
    );
  }
}
