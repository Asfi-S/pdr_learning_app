import 'dart:math';
import 'package:flutter/material.dart';

/// Aira-style анімований, чистий, без артефактів спідометр.
class SpeedometerResult extends StatefulWidget {
  final int percent;

  const SpeedometerResult({super.key, required this.percent});

  @override
  State<SpeedometerResult> createState() => _SpeedometerResultState();
}

class _SpeedometerResultState extends State<SpeedometerResult>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _value;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _value = Tween<double>(
      begin: 0,
      end: widget.percent.clamp(0, 100).toDouble(),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _value,
      builder: (_, __) {
        final v = _value.value;
        final color = _colorFor(v);

        return Column(
          children: [
            SizedBox(
              width: 260,
              height: 220,
              child: CustomPaint(
                painter: _SpeedometerPainter(
                  percent: v,
                  color: color,
                  isDark: theme.brightness == Brightness.dark,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "${v.toInt()}%",
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _labelFor(v),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        );
      },
    );
  }

  Color _colorFor(double p) {
    if (p >= 90) return Colors.lightGreenAccent.shade400;
    if (p >= 75) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  String _labelFor(double p) {
    if (p >= 90) return "Чудово! Ти майже готовий до іспиту.";
    if (p >= 75) return "Добре, але є що підтягнути.";
    if (p >= 50) return "Потрібно ще попрактикуватися.";
    return "Поки що слабувато — вчитись ще 😉";
  }
}

/// Painter без артефактів, одна кольорова дуга, стрілка.
class _SpeedometerPainter extends CustomPainter {
  final double percent;
  final Color color;
  final bool isDark;

  _SpeedometerPainter({
    required this.percent,
    required this.color,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 10);
    final radius = size.width / 2 - 24;

    const start = 3 * pi / 4;  // 135°
    const sweep = 3 * pi / 2;  // 270°
    final progress = sweep * (percent / 100);

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Фон
    final bg = Paint()
      ..color = isDark ? Colors.white10 : Colors.black12
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, start, sweep, false, bg);

    // Прогрес
    final fg = Paint()
      ..color = color
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, start, progress, false, fg);

    // Стрілка
    final angle = start + progress;
    final end = Offset(
      center.dx + (radius - 10) * cos(angle),
      center.dy + (radius - 10) * sin(angle),
    );

    final needle = Paint()
      ..color = color
      ..strokeWidth = 3;

    canvas.drawLine(center, end, needle);

    // Центр
    canvas.drawCircle(center, 5,
        Paint()..color = isDark ? Colors.white24 : Colors.black26);
    canvas.drawCircle(center, 3, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _SpeedometerPainter old) =>
      old.percent != percent || old.color != color;
}
