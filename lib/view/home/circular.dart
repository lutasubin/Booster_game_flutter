import 'dart:math' as math;
import 'package:flutter/material.dart';

class GaugeCircle extends StatelessWidget {
  final String label;
  final int percentage;
  final Color color;

  const GaugeCircle({
    super.key,
    required this.label,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CustomPaint(
            painter: GaugePainter(percentage: percentage, color: color),
            child: Center(
              child: Text(
                "$percentage%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Play',
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Play',
          ),
        ),
      ],
    );
  }
}

class GaugePainter extends CustomPainter {
  final int percentage;
  final Color color;

  GaugePainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Vòng tròn nền mờ
    final backgroundPaint =
        Paint()
          ..color = Colors.grey[850]!
          ..strokeWidth = 8
          ..style = PaintingStyle.stroke;
         
    canvas.drawCircle(center, radius - 10, backgroundPaint);

    // Vòng tròn màu chính (1 màu)
    final progressPaint =
        Paint()
          ..color = color
          ..strokeWidth = 8
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 10),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.color != color;
  }
}
