import 'dart:convert';
import 'package:flutter/material.dart';
import '../data/db_helper.dart';

class TheoryScreen extends StatefulWidget {
  const TheoryScreen({super.key});

  @override
  State<TheoryScreen> createState() => _TheoryScreenState();
}

class _TheoryScreenState extends State<TheoryScreen> {
  final DBHelper db = DBHelper();
  List<Map<String, dynamic>> allSections = [];
  List<Map<String, dynamic>> filteredSections = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSections();
  }

  Future<void> _loadSections() async {
    final data = await db.getSections();
    setState(() {
      allSections = data;
      filteredSections = data;
    });
  }

  void _search(String query) {
    setState(() {
      filteredSections = allSections.where((section) {
        final title = section['title'].toString().toLowerCase();
        final description = section['description'].toString().toLowerCase();
        return title.contains(query.toLowerCase()) ||
            description.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: const Text(
          'Теорія ПДР',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        elevation: 3,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _search,
              decoration: InputDecoration(
                hintText: 'Пошук по розділах...',
                prefixIcon: const Icon(Icons.search, color: Colors.redAccent),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: filteredSections.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredSections.length,
              itemBuilder: (context, index) {
                final section = filteredSections[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SectionDetailsScreen(
                              title: section['title'],
                              description: section['description'],
                              content: section['content'],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              section['description'],
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 🧠 Деталі розділу
class SectionDetailsScreen extends StatelessWidget {
  final String title;
  final String description;
  final String content;

  const SectionDetailsScreen({
    super.key,
    required this.title,
    required this.description,
    required this.content,
  });

  List<Map<String, dynamic>> _parseContent(String raw) {
    dynamic decoded = raw;

    try {
      int attempts = 0;
      while (decoded is String && attempts < 5) {
        decoded = decoded.trim();
        if (decoded.startsWith('[') || decoded.startsWith('{')) {
          decoded = jsonDecode(decoded);
        } else {
          break;
        }
        attempts++;
      }

      if (decoded is List) {
        return decoded.map<Map<String, dynamic>>((item) {
          if (item is Map<String, dynamic>) return item;
          if (item is Map) return Map<String, dynamic>.from(item);
          return {'number': '', 'text': item.toString(), 'imagePath': ''};
        }).toList();
      }
    } catch (e) {
      debugPrint('❌ JSON parse error: $e');
    }

    return [
      {'number': '', 'text': raw, 'imagePath': ''}
    ];
  }

  @override
  Widget build(BuildContext context) {
    final parsed = _parseContent(content);

    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            description,
            style: TextStyle(
              fontSize: 17,
              color: Colors.grey[700],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),

          ...parsed.map((item) {
            final number = item['number']?.toString() ?? '';
            final text = item['text']?.toString() ?? '';
            final imagePath = item['imagePath']?.toString() ?? '';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              child: ExpansionTile(
                tilePadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  number.isNotEmpty ? 'Пункт $number' : 'Текст розділу',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                children: [
                  if (imagePath.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[300],
                            height: 150,
                            alignment: Alignment.center,
                            child: const Text(
                              '⚠️ Зображення не знайдено',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
