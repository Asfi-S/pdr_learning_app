import 'package:flutter/material.dart';
import '../data/pdr_tests_loader.dart';
import '../models/test_question_model.dart';
import 'test_runner_screen.dart';

class TestMenuScreen extends StatefulWidget {
  const TestMenuScreen({super.key});

  @override
  State<TestMenuScreen> createState() => _TestMenuScreenState();
}

class _TestMenuScreenState extends State<TestMenuScreen> {
  List<TestQuestionModel> questions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    questions = await PdrTestsLoader.loadTests();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Тестування")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _modeCard(
            theme,
            title: "Тренувальний режим",
            subtitle: "Всі питання підряд, без таймера",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TestRunnerScreen(
                  questions: questions,
                  examMode: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _modeCard(
            theme,
            title: "Екзамен",
            subtitle: "20 випадкових питань + таймер",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TestRunnerScreen(
                  questions: _random20(),
                  examMode: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Випадкові 20 питань
  List<TestQuestionModel> _random20() {
    questions.shuffle();
    return questions.take(20).toList();
  }

  Widget _modeCard(
      ThemeData t, {
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return Card(
      color: t.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: t.textTheme.titleLarge),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        onTap: onTap,
      ),
    );
  }
}
