import 'package:flutter/material.dart';
import '../models/theory_item.dart';

class TheoryCard extends StatelessWidget {
  final TheoryItem item;

  const TheoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item.number}  ${item.title}',
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              item.text,
              style: TextStyle(
                color: scheme.onSurface.withOpacity(0.9),
                fontSize: 15,
                height: 1.45,
              ),
            ),

            if (item.imagePath != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(item.imagePath!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
