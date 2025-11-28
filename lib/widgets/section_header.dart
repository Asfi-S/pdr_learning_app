import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String text;

  const SectionHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: scheme.primary.withOpacity(0.25),
          width: 1.2,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: scheme.onSurface,
          fontSize: 16,
          height: 1.35,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
