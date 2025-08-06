import 'dart:math' as math;

import 'package:flutter/material.dart';

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  CircularProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Background circle
    final backgroundPaint =
        Paint()
          ..color = Colors.grey[800]!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );

    // Draw dots around the circle for visual enhancement
    final dotPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 60; i++) {
      final angle = (i / 60) * 2 * math.pi - math.pi / 2;
      final dotRadius = i / 60 <= progress ? 2.0 : 1.0;
      final dotColor = i / 60 <= progress ? color : Colors.grey[700]!;

      dotPaint.color = dotColor;

      final dotX = center.dx + (radius + 8) * math.cos(angle);
      final dotY = center.dy + (radius + 8) * math.sin(angle);

      canvas.drawCircle(Offset(dotX, dotY), dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
