import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

import '../models/test_question_model.dart';
import '../widgets/speedometer_result.dart';
import '../data/history_manager.dart';

class TestRunnerScreen extends StatefulWidget {
  final String title;
  final List<TestQuestionModel> questions;
  final bool withTimer;
  final bool trainingMode;
  final int? timeLimitSeconds;

  const TestRunnerScreen({
    super.key,
    required this.title,
    required this.questions,
    required this.withTimer,
    required this.trainingMode,
    this.timeLimitSeconds,
  });

  @override
  State<TestRunnerScreen> createState() => _TestRunnerScreenState();
}

class _TestRunnerScreenState extends State<TestRunnerScreen>
    with SingleTickerProviderStateMixin {
  int index = 0;
  int? selected;
  int correct = 0;
  bool answered = false;

  bool showAira = false;

  Timer? _timer;
  late int timeLeft;

  late AnimationController _airaController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    timeLeft = widget.timeLimitSeconds ?? 0;

    if (widget.withTimer && widget.timeLimitSeconds != null) {
      _startTimer();
    }

    _airaController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fade = CurvedAnimation(parent: _airaController, curve: Curves.easeOut);
    _slide =
        Tween(begin: const Offset(0, 0.25), end: Offset.zero).animate(_fade);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft <= 0) {
        t.cancel();
        _finishTest();
      } else {
        setState(() => timeLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _airaController.dispose();
    super.dispose();
  }

  void _showAiraExplanation() {
    if (!widget.trainingMode) return;
    if (widget.questions[index].explanation == null) return;

    setState(() {
      showAira = true;
    });
    _airaController.forward();
  }

  Future<void> _finishTest() async {
    await HistoryManager.add(
      HistoryItem(
        title: widget.title,
        total: widget.questions.length,
        right: correct,
        percent: ((correct / widget.questions.length) * 100).round(),
        date: DateTime.now(),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => _ResultScreen(
          title: widget.title,
          total: widget.questions.length,
          right: correct,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = widget.questions[index];

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}: ${index + 1}/${widget.questions.length}"),
        actions: [
          if (widget.withTimer)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  _formatTime(timeLeft),
                  style: const TextStyle(
                    fontSize: 18,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
        ],
      ),

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (index + 1) / widget.questions.length,
                  minHeight: 6,
                  backgroundColor:
                  theme.colorScheme.primary.withOpacity(0.15),
                ),

                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(q.question, style: theme.textTheme.titleLarge),
                ),

                const SizedBox(height: 12),

                if (q.imagePath != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(q.imagePath!),
                  ),
                  const SizedBox(height: 16),
                ],

                Expanded(
                  child: ListView.builder(
                    itemCount: q.answers.length,
                    itemBuilder: (_, i) {
                      Color tileColor = theme.cardColor;
                      Color borderColor = Colors.transparent;

                      if (!answered && selected == i) {
                        tileColor =
                            theme.colorScheme.primary.withOpacity(0.20);
                        borderColor = theme.colorScheme.primary;
                      }

                      if (answered) {
                        if (i == q.correctIndex) {
                          tileColor = Colors.green.shade400;
                          borderColor = Colors.green.shade700;
                        } else if (selected == i) {
                          tileColor = Colors.red.shade400;
                          borderColor = Colors.red.shade700;
                        }
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          tileColor: tileColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: borderColor, width: 2),
                          ),
                          title: Text(q.answers[i],
                              style: theme.textTheme.bodyLarge),
                          onTap: answered
                              ? null
                              : () => setState(() => selected = i),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selected == null
                        ? null
                        : () {
                      if (!answered) {
                        setState(() {
                          answered = true;
                          if (selected == q.correctIndex)
                            correct++;
                          else
                            _showAiraExplanation();
                        });
                        return;
                      }

                      if (index < widget.questions.length - 1) {
                        setState(() {
                          index++;
                          selected = null;
                          answered = false;
                          showAira = false;
                          _airaController.reset();
                        });
                      } else {
                        _timer?.cancel();
                        _finishTest();
                      }
                    },
                    child: Text(
                      !answered
                          ? "Вибрати"
                          : (index == widget.questions.length - 1
                          ? "Завершити"
                          : "Далі"),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// 🔥 AIRA ASSISTANT POPUP (only training mode)
          if (showAira && widget.trainingMode)
            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: _slide,
                child: FadeTransition(
                  opacity: _fade,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/aira_assistant.png",
                          width: 70,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            q.explanation ?? "Помилка",
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _airaController.reverse();
                            setState(() => showAira = false);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
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
  final String title;
  final int total;
  final int right;

  const _ResultScreen({
    required this.title,
    required this.total,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (right / total * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text("Результат тесту")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),

              SpeedometerResult(percent: percent),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Повернутися"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
