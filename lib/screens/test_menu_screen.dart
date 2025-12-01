import 'package:flutter/material.dart';
import '../data/pdr_tests_loader.dart';
import '../models/test_question_model.dart';
import '../utils/test_utils.dart';
import 'test_runner_screen.dart';

class TestMenuScreen extends StatelessWidget {
  const TestMenuScreen({super.key});

  Future<void> _startTraining(BuildContext context) async {
    final all = await PdrTestsLoader.loadAll();

    final randomized = TestUtils.randomizeQuestions(all)
        .map(TestUtils.randomizeAnswers)
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TestRunnerScreen(
          title: 'Тренувальний режим',
          questions: randomized,
          withTimer: false,
          trainingMode: true,
          timeLimitSeconds: null,
        ),
      ),
    );
  }

  Future<void> _startExam(BuildContext context) async {
    final all = await PdrTestsLoader.loadAll();

    final randomized = TestUtils.randomizeQuestions(all)
        .take(20)
        .map(TestUtils.randomizeAnswers)
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TestRunnerScreen(
          title: 'Екзаменаційний режим',
          questions: randomized,
          withTimer: true,
          trainingMode: false,
          timeLimitSeconds: 1200,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textDim = theme.colorScheme.onSurface.withOpacity(0.6);

    Widget card(String title, String subtitle, IconData icon, VoidCallback tap) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: tap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor:
                  theme.colorScheme.primary.withOpacity(0.2),
                  child: Icon(icon, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(subtitle,
                          style:
                          theme.textTheme.bodyMedium!.copyWith(color: textDim)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded)
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Тестування ПДР')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            card('Тренувальний режим',
                'Всі питання підряд, без таймера', Icons.school_rounded,
                    () => _startTraining(context)),
            const SizedBox(height: 12),
            card('Екзаменаційний режим',
                '20 випадкових питань, з таймером', Icons.timer_rounded,
                    () => _startExam(context)),
          ],
        ),
      ),
    );
  }
}
