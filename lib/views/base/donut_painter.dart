import 'dart:math' as math;
import 'package:flutter/material.dart';

class DonutPainter extends CustomPainter {
  final List<dynamic> data;

  DonutPainter({required this.data});

  static const colors = [
    Color(0xFF90CAF9),
    Color(0xFF455A64),
    Color(0xFF263238),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final total =
    data.fold<double>(0, (s, e) => s + e.percentage);
    final cx = size.width / 2;
    final cy = size.height * 0.95;
    final radius = size.width * 0.25;
    final stroke = radius * 0.32;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    double startAngle = math.pi;
    const sweepTotal = math.pi;

    for (int i = 0; i < data.length; i++) {
      final sweep = (data[i].percentage / total) * sweepTotal;
      paint.color = colors[i % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        startAngle,
        sweep,
        false,
        paint,
      );
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(DonutPainter old) => true;
}