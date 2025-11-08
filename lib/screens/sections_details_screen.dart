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

  List<Map<String, dynamic>> _parseContent(String raw) {
    try {
      dynamic decoded = jsonDecode(raw);

      if (decoded is String) {
        decoded = jsonDecode(decoded);
      }

      if (decoded is List) {
        return decoded.map<Map<String, dynamic>>((item) {
          if (item is Map<String, dynamic>) return item;
          if (item is Map) {
            return Map<String, dynamic>.from(item);
          }
          return {'number': '', 'text': item.toString()};
        }).toList();
      }
    } catch (e) {
      debugPrint('❌ JSON decode error: $e');
    }

    return [
      {'number': '', 'text': raw}
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = _parseContent(content);

    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final number = item['number']?.toString() ?? '';
                  final text = item['text']?.toString() ?? '';

                  return Card(
                    color: Colors.white,
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (number.isNotEmpty)
                            Text(
                              'Пункт $number',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.redAccent,
                              ),
                            ),
                          const SizedBox(height: 6),
                          Text(
                            text,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
