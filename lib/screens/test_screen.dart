import 'package:flutter/material.dart';
import '../data/pdr_tests_loader.dart';
import '../models/test_question_model.dart';
import 'test_runner_screen.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<TestQuestionModel> tests = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    tests = await PdrTestsLoader.loadTests();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Тестування')),
      body: tests.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TestRunnerScreen(questions: tests),
              ),
            );
          },
          child: const Text(
            "Почати тест",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
