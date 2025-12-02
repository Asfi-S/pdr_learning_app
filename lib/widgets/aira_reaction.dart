import 'package:flutter/material.dart';

enum AiraMood { happy, sad, angry }

class AiraReaction extends StatelessWidget {
  final AiraMood mood;
  final String text;

  const AiraReaction({
    super.key,
    required this.mood,
    required this.text,
  });

  String _getImage() {
    switch (mood) {
      case AiraMood.happy:
        return "assets/images/aira_happy.png";
      case AiraMood.angry:
        return "assets/images/aira_angry.png";
      default:
        return "assets/images/aira_sad.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: 1,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  _getImage(),
                  width: 65,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
