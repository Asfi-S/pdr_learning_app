import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/history_manager.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryItem> history = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    history = await HistoryManager.load();
    setState(() => loading = false);
  }

  String _formatDate(DateTime date) {
    final d = DateFormat("dd.MM.yyyy").format(date);
    final t = DateFormat("HH:mm").format(date);
    return "$d • $t";
  }

  // 🎨 Колір за результатом
  Color _percentColor(int percent) {
    if (percent >= 90) return Colors.greenAccent.shade400;
    if (percent >= 70) return Colors.lightGreen;
    if (percent >= 50) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  // 🧠 Іконка за результатом
  IconData _resultIcon(int percent) {
    if (percent >= 90) return Icons.verified;
    if (percent >= 70) return Icons.check_circle;
    if (percent >= 50) return Icons.warning_amber_rounded;
    return Icons.cancel;
  }

  Future<void> _confirmClear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Очистити історію?"),
        content: const Text(
          "Усі результати тестів будуть видалені назавжди.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Скасувати"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Очистити"),
          ),
        ],
      ),
    );

    if (ok == true) {
      await HistoryManager.clear();
      setState(() => history.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Історія тестів"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _confirmClear,
          ),
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : history.isEmpty
          ? const Center(
        child: Text(
          "Поки що немає проходжень.",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: history.length,
        itemBuilder: (_, i) {
          final h = history[i];
          final color = _percentColor(h.percent);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),

            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border(
                  left: BorderSide(
                    color: color,
                    width: 5,
                  ),
                ),
              ),

              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),

                leading: Icon(
                  _resultIcon(h.percent),
                  color: color,
                  size: 30,
                ),

                title: RichText(
                  text: TextSpan(
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                    ),
                    children: [
                      TextSpan(text: "${h.title} — "),
                      TextSpan(
                        text: "${h.percent}%",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),

                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    "Правильних: ${h.right}/${h.total}\n"
                        "${_formatDate(h.date)}",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
