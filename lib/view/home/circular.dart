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
          width: 90,
          height: 90,
          child: CustomPaint(
            painter: GaugePainter(percentage: percentage, color: color),
            child: Center(
              child: Text(
                "$percentage%",
                style: const TextStyle(
                  fontFamily: 'Play',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Play',
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
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

    // Vẽ vòng tròn viền trắng ngoài
    final borderPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
    canvas.drawCircle(center, radius - 1, borderPaint);

    // Vẽ các vạch
    const tickCount = 45; // tổng số vạch
    final tickPaint =
        Paint()
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.butt;

    final activeTicks = (percentage / 100 * tickCount).round();

    for (int i = 0; i < tickCount; i++) {
      final angle = (i / tickCount) * 2 * math.pi - math.pi / 2;

      tickPaint.color = i < activeTicks ? color : Colors.grey[800]!;

      const tickLength = 8.0;

      final startX = center.dx + (radius - tickLength - 4) * math.cos(angle);
      final startY = center.dy + (radius - tickLength - 4) * math.sin(angle);

      final endX = center.dx + (radius - 4) * math.cos(angle);
      final endY = center.dy + (radius - 4) * math.sin(angle);

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.color != color;
  }
}
