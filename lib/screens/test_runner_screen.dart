import 'package:flutter/material.dart';
import '../models/test_question_model.dart';
import 'dart:async';

class TestRunnerScreen extends StatefulWidget {
  final List<TestQuestionModel> questions;
  final bool examMode; // 🔥 Додаємо параметр

  const TestRunnerScreen({
    super.key,
    required this.questions,
    this.examMode = false, // за замовчуванням тренувальний режим
  });

  @override
  State<TestRunnerScreen> createState() => _TestRunnerScreenState();
}

class _TestRunnerScreenState extends State<TestRunnerScreen> {
  int index = 0;
  int? selected;
  int correct = 0;
  bool answered = false;

  Timer? timer;
  int timeLeft = 120; // лише для екзамена

  @override
  void initState() {
    super.initState();

    // 🔥 Таймер запускається ТІЛЬКИ якщо examMode = true
    if (widget.examMode) {
      startTimer();
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (timeLeft == 0) {
        timer?.cancel();
        _finishTest();
      } else {
        setState(() => timeLeft--);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _finishTest() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            _ResultScreen(total: widget.questions.length, right: correct),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = widget.questions[index];

    return Scaffold(
      appBar: AppBar(
        title: Text("Питання ${index + 1}/${widget.questions.length}"),

        // 🔥 Показуємо таймер тільки в екзаменаційному режимі
        actions: widget.examMode
            ? [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              _formatTime(timeLeft),
              style: const TextStyle(fontSize: 20),
            ),
          )
        ]
            : [],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(q.question, style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),

            if (q.imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(q.imagePath!),
              ),

            const SizedBox(height: 20),

            ...List.generate(q.answers.length, (i) {
              Color? tile = theme.cardColor;

              if (answered) {
                if (i == q.correctIndex) tile = Colors.green.shade400;
                if (selected == i && selected != q.correctIndex)
                  tile = Colors.red.shade400;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  tileColor: tile,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  title: Text(q.answers[i]),
                  onTap: answered
                      ? null
                      : () => setState(() => selected = i),
                ),
              );
            }),

            const Spacer(),

            ElevatedButton(
              onPressed: selected == null
                  ? null
                  : () {
                if (!answered) {
                  answered = true;

                  if (selected == q.correctIndex) correct++;

                  setState(() {});
                  return;
                }

                if (index < widget.questions.length - 1) {
                  setState(() {
                    index++;
                    selected = null;
                    answered = false;
                  });
                } else {
                  timer?.cancel();
                  _finishTest();
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

  String _formatTime(int sec) {
    final m = (sec ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }
}

class _ResultScreen extends StatelessWidget {
  final int total;
  final int right;

  const _ResultScreen({required this.total, required this.right});

  @override
  Widget build(BuildContext context) {
    final percent = (right / total * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text("Результат тесту")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$right / $total",
                style: const TextStyle(fontSize: 42)),
            const SizedBox(height: 12),
            Text("Результат: $percent%"),
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
