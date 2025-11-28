import 'package:flutter/material.dart';
import '../models/test_question_model.dart';

class TestQuestionScreen extends StatefulWidget {
  final TestQuestionModel question;

  const TestQuestionScreen({super.key, required this.question});

  @override
  State<TestQuestionScreen> createState() => _TestQuestionScreenState();
}

class _TestQuestionScreenState extends State<TestQuestionScreen> {
  int? selected;
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Питання")),
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
              final bool isCorrect = i == q.correctIndex;

              Color tileColor = theme.cardColor;

              if (submitted) {
                if (selected == i && isCorrect) {
                  tileColor = Colors.green.shade400;
                } else if (selected == i && !isCorrect) {
                  tileColor = Colors.red.shade400;
                } else if (isCorrect) {
                  tileColor = Colors.green.shade300;
                }
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  tileColor: tileColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  title: Text(q.answers[i], style: theme.textTheme.bodyLarge),
                  onTap: () {
                    if (submitted) return;
                    setState(() => selected = i);
                  },
                ),
              );
            }),

            const Spacer(),

            ElevatedButton(
              onPressed: selected == null
                  ? null
                  : () {
                setState(() => submitted = true);
              },
              child: const Text("Перевірити"),
            ),
          ],
        ),
      ),
    );
  }
}
