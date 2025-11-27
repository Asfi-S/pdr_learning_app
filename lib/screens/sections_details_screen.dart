import 'package:flutter/material.dart';
import '../models/section_model.dart';
import '../models/theory_item.dart';

class SectionDetailsScreen extends StatelessWidget {
  final SectionModel section;

  const SectionDetailsScreen({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(section.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(section.description, theme),
            const SizedBox(height: 20),
            ...section.theory.map((item) => _item(item, theme)),
          ],
        ),
      ),
    );
  }

  Widget _header(String text, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodyLarge,
      ),
    );
  }

  Widget _item(TheoryItem item, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(
            color: theme.colorScheme.primary,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.25),
            blurRadius: 6,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${item.number}.  ${item.title}',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            item.text,
            style: theme.textTheme.bodyMedium!.copyWith(height: 1.5),
          ),
          if (item.imagePath != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(item.imagePath!),
            )
          ],
        ],
      ),
    );
  }
}
