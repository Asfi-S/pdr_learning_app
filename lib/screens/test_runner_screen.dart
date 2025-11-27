import 'package:flutter/material.dart';
import '../models/test_question_model.dart';

class TestRunnerScreen extends StatefulWidget {
  final List<TestQuestionModel> questions;

  const TestRunnerScreen({super.key, required this.questions});

  @override
  State<TestRunnerScreen> createState() => _TestRunnerScreenState();
}

class _TestRunnerScreenState extends State<TestRunnerScreen> {
  int index = 0;
  int? selected;
  int correct = 0;
  bool answered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = widget.questions[index];

    return Scaffold(
      appBar: AppBar(
        title: Text("Питання ${index + 1}/${widget.questions.length}"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ❓ ПИТАННЯ
            Text(
              q.question,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            if (q.imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(q.imagePath!),
              ),

            const SizedBox(height: 20),

            /// 🟦 ВАРІАНТИ ВІДПОВІДЕЙ
            ...List.generate(q.answers.length, (i) {
              Color? tile = theme.cardColor;

              if (answered) {
                if (i == q.correctIndex) tile = Colors.green.shade400;
                if (selected == i && selected != q.correctIndex) tile = Colors.red.shade400;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  tileColor: tile,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  title: Text(q.answers[i], style: theme.textTheme.bodyLarge),
                  onTap: answered
                      ? null
                      : () {
                    setState(() {
                      selected = i;
                    });
                  },
                ),
              );
            }),

            const Spacer(),

            /// 🔘 КНОПКА ДАЛІ / ЗАВЕРШИТИ
            ElevatedButton(
              onPressed: selected == null
                  ? null
                  : () {
                if (!answered) {
                  answered = true;
                  if (selected == q.correctIndex) {
                    correct++;
                  }
                  setState(() {});
                  return;
                }

                /// 👉 Перейти до наступного питання
                if (index < widget.questions.length - 1) {
                  setState(() {
                    index++;
                    selected = null;
                    answered = false;
                  });
                } else {
                  /// 👉 Показати результат
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => _ResultScreen(
                        total: widget.questions.length,
                        right: correct,
                      ),
                    ),
                  );
                }
              },
              child: Text(
                answered
                    ? (index == widget.questions.length - 1
                    ? "Завершити"
                    : "Далі")
                    : "Вибрати",
                style: const TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ResultScreen extends StatelessWidget {
  final int total;
  final int right;

  const _ResultScreen({required this.total, required this.right});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (right / total * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text("Результат тесту")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$right / $total",
              style: theme.textTheme.titleLarge!.copyWith(fontSize: 42),
            ),
            const SizedBox(height: 12),
            Text(
              "Результат: $percent%",
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Повернутися"),
            )
          ],
        ),
      ),
    );
  }
}
