import 'package:flutter/material.dart';
import '../data/db_helper.dart';

class TheoryScreen extends StatefulWidget {
  const TheoryScreen({super.key});

  @override
  State<TheoryScreen> createState() => _TheoryScreenState();
}

class _TheoryScreenState extends State<TheoryScreen> {
  final DBHelper db = DBHelper();
  List<Map<String, dynamic>> sections = [];

  @override
  void initState() {
    super.initState();
    _loadSections();
  }

  Future<void> _loadSections() async {
    final data = await db.getSections();
    setState(() {
      sections = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Теорія ПДР'),
        backgroundColor: Colors.redAccent,
      ),
      body: sections.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(section['title']),
              subtitle: Text(section['description']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SectionDetailsScreen(
                      title: section['title'],
                      content: section['content'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class SectionDetailsScreen extends StatelessWidget {
  final String title;
  final String content;

  const SectionDetailsScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(content),
      ),
    );
  }
}
