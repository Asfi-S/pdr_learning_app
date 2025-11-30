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
          withTimer: false, // без таймера
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
          timeLimitSeconds: 1200,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface.withOpacity(0.7);

    Widget buildCard({
      required String title,
      required String subtitle,
      required IconData icon,
      required VoidCallback onTap,
    }) {
      return Card(
        color: theme.cardColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                  child: Icon(icon, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(subtitle,
                          style: theme.textTheme.bodyMedium!
                              .copyWith(color: onSurface)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 18),
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
            buildCard(
              title: 'Тренувальний режим',
              subtitle: 'Всі питання підряд, без таймера',
              icon: Icons.school_rounded,
              onTap: () => _startTraining(context),
            ),
            const SizedBox(height: 12),
            buildCard(
              title: 'Екзаменаційний режим',
              subtitle: '20 випадкових питань, з таймером',
              icon: Icons.timer_rounded,
              onTap: () => _startExam(context),
            ),
          ],
        ),
      ),
    );
  }
}
