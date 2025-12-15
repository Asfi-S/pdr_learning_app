import 'package:flutter/material.dart';
import '../data/pdr_tests_loader.dart';
import '../models/test_question_model.dart';
import '../utils/test_utils.dart';
import '../data/history_manager.dart';
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

    Widget card({
      required String title,
      required String subtitle,
      required IconData icon,
      required VoidCallback tap,
      Widget? badge,
      Widget? footer,
    }) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: tap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
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
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  title,
                                  style: theme.textTheme.titleLarge,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (badge != null) ...[
                                const SizedBox(width: 8),
                                badge,
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: textDim),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
                if (footer != null) ...[
                  const SizedBox(height: 10),
                  footer,
                ],
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Тестування ПДР')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline,
                      size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Тренувальний режим — для навчання. Екзаменаційний — як на реальному іспиті.",
                      style: theme.textTheme.bodySmall!
                          .copyWith(color: textDim),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              card(
                title: 'Тренувальний режим',
                subtitle: 'Всі питання підряд, без таймера',
                icon: Icons.school_rounded,
                tap: () => _startTraining(context),
                badge: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Рекомендовано",
                    style: theme.textTheme.labelSmall!
                        .copyWith(color: theme.colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FutureBuilder<HistoryItem?>(
                future: HistoryManager.last(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return card(
                      title: 'Екзаменаційний режим',
                      subtitle: '20 випадкових питань, з таймером',
                      icon: Icons.timer_rounded,
                      tap: () => _startExam(context),
                    );
                  }

                  final last = snapshot.data!;

                  return card(
                    title: 'Екзаменаційний режим',
                    subtitle: '20 випадкових питань, з таймером',
                    icon: Icons.timer_rounded,
                    tap: () => _startExam(context),
                    footer: Row(
                      children: [
                        Icon(Icons.history, size: 16, color: textDim),
                        const SizedBox(width: 6),
                        Text(
                          "Останній результат: ${last.right}/${last.total}",
                          style: theme.textTheme.bodySmall!
                              .copyWith(color: textDim),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
