import 'package:flutter/material.dart';
import '../data/history_manager.dart';
import 'package:intl/intl.dart';

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

  Future<void> _confirmClear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Очистити історію?"),
        content: const Text("Усі результати тестів будуть видалені назавжди."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Скасувати")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Очистити")),
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
            icon: const Icon(Icons.delete),
            onPressed: _confirmClear,
          )
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

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 3,

            child: ListTile(
              title: Text(
                "${h.title} — ${h.percent}%",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 18,
                ),
              ),

              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  "Правильних: ${h.right}/${h.total}\n"
                      "${_formatDate(h.date)}",
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
