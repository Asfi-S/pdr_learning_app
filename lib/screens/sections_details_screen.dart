import 'dart:convert';
import 'package:flutter/material.dart';

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

  /// 🧩 Розумний декодер — витягує вкладені JSON навіть 3 рівнів
  List<Map<String, dynamic>> _parseContent(String raw) {
    try {
      dynamic decoded = raw;

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
          if (item is Map) {
            return {
              'number': item['number'] ?? '',
              'text': item['text'] ?? '',
              'imagePath': item['imagePath'] ?? '',
            };
          }
          return {'number': '', 'text': item.toString(), 'imagePath': ''};
        }).toList();
      }

      if (decoded is Map) {
        return [Map<String, dynamic>.from(decoded)];
      }

      debugPrint('⚠️ Невідомий формат: $decoded');
    } catch (e, s) {
      debugPrint('❌ JSON decode error: $e');
      debugPrint('📜 Stack: $s');
    }

    return [
      {'number': '', 'text': raw, 'imagePath': ''}
    ];
  }


    return [
      {'number': '', 'text': raw, 'imagePath': ''}
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = _parseContent(content);
    for (final i in items) {
      debugPrint('🧩 ${i['number']} → ${i['imagePath']}');
    }

    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final number = item['number'] ?? '';
            final text = item['text'] ?? '';
            final imagePath = (item['imagePath'] ?? '').trim();

            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Пункт $number',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 8),

                    if (imagePath.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 6)
                          ],
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[300],
                            padding: const EdgeInsets.all(12),
                            alignment: Alignment.center,
                            child: const Text(
                              '⚠️ Зображення не знайдено',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ),
                      ),

                    Text(text, style: const TextStyle(fontSize: 16, height: 1.5)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
