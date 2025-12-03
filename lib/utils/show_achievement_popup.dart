import 'package:flutter/material.dart';
import '../widgets/achievement_popup.dart';

Future<void> showAchievementPopup(
    BuildContext context, {
      required String title,
      required String description,
      required String icon,
    }) async {
  final overlay = Overlay.of(context);

  final entry = OverlayEntry(
    builder: (_) => AchievementPopup(
      title: title,
      description: description,
      iconPath: icon,
    ),
  );

  overlay.insert(entry);

  await Future.delayed(const Duration(seconds: 3));
  entry.remove();
}
