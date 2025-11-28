import 'dart:math';
import 'package:flutter/material.dart';

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
      duration: const Duration(milliseconds: 1600),
    );

    _value = Tween<double>(
      begin: 0,
      end: widget.percent.toDouble().clamp(0, 100),
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
        final current = _value.value;
        final color = _colorForPercent(current);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 230,
              height: 230,
              child: CustomPaint(
                painter: _SpeedometerPainter(
                  percent: current,
                  accentColor: color,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${current.toInt()}%',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _labelForPercent(current),
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }


  Color _colorForPercent(double p) {
    if (p >= 90) return const Color(0xFF6EFF45); // яскравий зелений
    if (p >= 60) return Colors.amberAccent.shade200;
    return Colors.redAccent;
  }

  String _labelForPercent(double p) {
    if (p >= 90) return 'Чудово! Ти майже готовий до іспиту.';
    if (p >= 75) return 'Добре, але є що підтягнути.';
    if (p >= 50) return 'Потрібно ще попрактикуватися.';
    return 'Поки що слабувато — варто вчитись більше 😉';
  }
}


class _SpeedometerPainter extends CustomPainter {
  final double percent;
  final Color accentColor;

  _SpeedometerPainter({
    required this.percent,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 24;

    // 135° → 405° (діапазон)
    final startAngle = pi * 0.75;
    final sweepAngle = pi * 1.5;

    // Фонова дуга
    final bgPaint = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );


    Shader shader;

    if (percent >= 90) {
      shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        colors: [
          accentColor,
          accentColor.withOpacity(0.8),
        ],
        stops: const [0.0, 0.85],
        transform: GradientRotation(startAngle),
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    } else {
      shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        colors: const [
          Color(0xFFFF4B6E),
          Color(0xFFFF8A4D),
          Color(0xFFFFE46A),
        ],
        stops: const [0.0, 0.45, 0.80],
        transform: GradientRotation(startAngle),
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    }

    final progressPaint = Paint()
      ..shader = shader
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressAngle = sweepAngle * (percent / 100);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      progressAngle,
      false,
      progressPaint,
    );

    final glowPaint = Paint()
      ..color = accentColor.withOpacity(0.25)
      ..strokeWidth = 28
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      progressAngle,
      false,
      glowPaint,
    );

    _drawNeedle(canvas, center, radius, startAngle, sweepAngle);

    canvas.drawCircle(center, 4, Paint()..color = Colors.black26);
    canvas.drawCircle(center, 2, Paint()..color = accentColor);
  }

  void _drawNeedle(Canvas canvas, Offset center, double radius,
      double startAngle, double sweepAngle) {
    final angle = startAngle + sweepAngle * (percent / 100);
    final end = Offset(
      center.dx + (radius - 12) * cos(angle),
      center.dy + (radius - 12) * sin(angle),
    );

    final needle = Paint()
      ..color = accentColor
      ..strokeWidth = 3;

    final glow = Paint()
      ..color = accentColor.withOpacity(0.55)
      ..strokeWidth = 7
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawLine(center, end, glow);
    canvas.drawLine(center, end, needle);
  }

  @override
  bool shouldRepaint(_SpeedometerPainter oldDelegate) {
    return oldDelegate.percent != percent ||
        oldDelegate.accentColor != accentColor;
  }
}
