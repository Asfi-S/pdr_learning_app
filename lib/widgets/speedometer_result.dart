import 'package:flutter/material.dart';
import 'dart:math';

class SpeedometerResult extends StatefulWidget {
  final int percent; // 0–100

  const SpeedometerResult({super.key, required this.percent});

  @override
  State<SpeedometerResult> createState() => _SpeedometerResultState();
}

class _SpeedometerResultState extends State<SpeedometerResult>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationValue;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animationValue = Tween<double>(
      begin: 0,
      end: widget.percent.toDouble(),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
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
      animation: _animationValue,
      builder: (_, __) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 220,
              height: 220,
              child: CustomPaint(
                painter: _SpeedometerPainter(_animationValue.value),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${_animationValue.value.toInt()}%',
              style: theme.textTheme.titleLarge!.copyWith(
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SpeedometerPainter extends CustomPainter {
  final double percent; // 0–100

  _SpeedometerPainter(this.percent);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    final startAngle = pi * 0.75; // 135°
    final sweepAngle = pi * 1.5;  // 270°

    // Фонова дуга
    final backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      backgroundPaint,
    );

    // Відсоток дуги
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: pi * 2,
        colors: [
          Colors.redAccent,
          Colors.amber,
          Colors.greenAccent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
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
  }

  @override
  bool shouldRepaint(covariant _SpeedometerPainter oldDelegate) {
    return oldDelegate.percent != percent;
  }
}
