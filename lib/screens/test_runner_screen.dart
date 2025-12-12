import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../models/test_question_model.dart';
import '../widgets/speedometer_result.dart';
import '../data/history_manager.dart';
import '../data/user_profile_manager.dart';
import '../data/achievements_manager.dart';

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
  int? selectedAnswer;
  int correctAnswers = 0;

  bool answered = false;
  bool showAira = false;

  // AIRA state
  String airaImage = "";
  String airaText = "";
  int wrongStreak = 0;

  // AIRA animations
  late AnimationController airaController;
  late Animation<Offset> slideAnimation;
  late Animation<double> fadeAnimation;

  Timer? timer;
  late int timeLeft;

  @override
  void initState() {
    super.initState();

    timeLeft = widget.timeLimitSeconds ?? 0;

    if (widget.withTimer && widget.timeLimitSeconds != null) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (timeLeft <= 0) {
          _finishTest();
        } else {
          setState(() => timeLeft--);
        }
      });
    }

    airaController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    fadeAnimation = CurvedAnimation(
      parent: airaController,
      curve: Curves.easeOut,
    );

    slideAnimation = Tween(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(fadeAnimation);
  }

  @override
  void dispose() {
    timer?.cancel();
    airaController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------
  // 🟣 ДІАЛОГ ПІДТВЕРДЖЕННЯ ВИХОДУ
  // ----------------------------------------------------
  Future<bool> _confirmExit() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Вийти з тесту?"),
        content: const Text(
          "Ваш прогрес буде втрачено. Ви впевнені, що хочете завершити тест?",
        ),
        actions: [
          TextButton(
            child: const Text("Скасувати"),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text("Вийти"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    ) ??
        false;
  }

  Future<void> _registerAnswer(bool isCorrect, TestQuestionModel q) async {
    final profile = await UserProfileManager.loadProfile();

    if (isCorrect) {
      correctAnswers++;
      profile.correctAnswers++;
      profile.addXP(5);
      wrongStreak = 0;

      airaImage = "assets/images/aira_happy.gif";
      airaText = _random([
        "Молодець ❤️",
        "Так тримати ⭐",
        "Я знала, що ти зможеш 😺",
        "Ого, красиво! 🔥",
        "Ти на правильному шляху 🌿"
      ]);

    } else {
      wrongStreak++;
      profile.wrongAnswers++;

      if (wrongStreak >= 5) {
        airaImage = "assets/images/aira_angry.gif";
        airaText = _random([
          "${q.explanation}\n\nТи хоч стараєшся?",
          "${q.explanation}\n\nНу скільки можна? 😾",
          "${q.explanation}\n\nАйра вже сердиться...",
          "${q.explanation}\n\nЯ починаю хвилюватись за тебе 😠",
          "${q.explanation}\n\nСхоже, ти сьогодні воюєш з ПДР 🤨",
          "${q.explanation}\n\nЩе одна така відповідь — і я піду пити чай 😤"
        ]);

      } else {
        airaImage = "assets/images/aira_sad.gif";
        airaText = _random([
          q.explanation ?? "Помилка.",
          "${q.explanation}\n\nТрішки помилився... 😿",
          "${q.explanation}\n\nНе засмучуйся, вийде ще ✨",
          "${q.explanation}\n\nХух... нічого, наступного разу краще 🫂",
          "${q.explanation}\n\nАйрі сумно… але я вірю в тебе 💔",
          "${q.explanation}\n\nНу-у, майже 😔"
        ]);
      }
    }

    await UserProfileManager.saveProfile(profile);

    if (widget.trainingMode) {
      setState(() => showAira = true);
      airaController.forward(from: 0);
    }
  }

  String _random(List<String> list) =>
      list[Random().nextInt(list.length)];

  Future<void> _onPressNext() async {
    final q = widget.questions[index];

    if (!answered) {
      if (selectedAnswer == null) return;

      setState(() => answered = true);

      final isCorrect = selectedAnswer == q.correctIndex;
      await _registerAnswer(isCorrect, q);

      return;
    }

    if (index < widget.questions.length - 1) {
      setState(() {
        index++;
        selectedAnswer = null;
        answered = false;
        showAira = false;
        airaController.reset();
      });
    } else {
      _finishTest();
    }
  }

  Future<void> _finishTest() async {
    timer?.cancel();

    await HistoryManager.add(
      HistoryItem(
        title: widget.title,
        total: widget.questions.length,
        right: correctAnswers,
        percent: ((correctAnswers / widget.questions.length) * 100).round(),
        date: DateTime.now(),
      ),
    );

    await UserProfileManager.addTestPassed();

    final profile = await UserProfileManager.loadProfile();
    await AchievementsManager.check(profile, context);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => _ResultScreen(
          title: widget.title,
          total: widget.questions.length,
          right: correctAnswers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[index];
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async => await _confirmExit(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final exit = await _confirmExit();
              if (exit) Navigator.pop(context);
            },
          ),
          title: Text("${widget.title}: ${index + 1}/${widget.questions.length}"),
          actions: [
            if (widget.withTimer)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(child: Text(_formatTime(timeLeft))),
              ),
          ],
        ),
        body: Stack(
          children: [
            _buildTestUI(q, theme),
            if (showAira && widget.trainingMode) _buildAira(),
          ],
        ),
      ),
    );
  }

  Widget _buildTestUI(TestQuestionModel q, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: (index + 1) / widget.questions.length,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(q.question, style: theme.textTheme.titleLarge),
          ),
          if (q.imagePath != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(q.imagePath!),
            ),
          ],
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: q.answers.length,
              itemBuilder: (_, i) => _buildAnswerTile(q, i, theme),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
              (!answered && selectedAnswer == null) ? null : _onPressNext,
              child: Text(
                !answered
                    ? "Вибрати"
                    : (index == widget.questions.length - 1 ? "Завершити" : "Далі"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerTile(TestQuestionModel q, int i, ThemeData theme) {
    final bool isCorrect = answered && i == q.correctIndex;
    final bool isWrong = answered && selectedAnswer == i && i != q.correctIndex;

    Color tileColor = theme.cardColor;
    Color borderColor = Colors.transparent;

    if (!answered && selectedAnswer == i) {
      tileColor = theme.colorScheme.primary.withOpacity(0.25);
      borderColor = theme.colorScheme.primary;
    }

    if (isCorrect) {
      tileColor = Colors.green.shade400;
      borderColor = Colors.green.shade700;
    }

    if (isWrong) {
      tileColor = Colors.red.shade400;
      borderColor = Colors.red.shade700;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        tileColor: tileColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: borderColor, width: 2),
        ),
        title: Text(q.answers[i]),
        onTap: answered ? null : () => setState(() => selectedAnswer = i),
      ),
    );
  }

  Widget _buildAira() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 80,
      child: IgnorePointer(
        ignoring: true,
        child: SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.28),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    airaImage,
                    width: 70,
                    height: 70,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      airaText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(int sec) {
    final m = (sec ~/ 60).toString().padLeft(2, "0");
    final s = (sec % 60).toString().padLeft(2, "0");
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
      appBar: AppBar(title: const Text("Результат")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
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
