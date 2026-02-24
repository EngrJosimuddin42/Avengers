import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class LinePainter extends CustomPainter {
  final List<double> points;

  LinePainter({required this.points});

  static const String _fontFamily = 'TikTokSans';

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    const topPad  = 20.0;
    const botPad  = 24.0;
    const rightPad = 28.0;
    final drawH   = size.height - topPad - botPad;
    final drawW   = size.width - rightPad;
    final step = points.length > 1 ? drawW / (points.length - 1) : drawW;

    Offset pointAt(int i) => Offset(
      i * step,
      topPad + drawH * (1 - points[i].clamp(0.0, 1.0)),
    );

    // Grid Lines
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1;

    final solidPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1;

    const yLabels = {'36': 0.0, '24': 0.33, '12': 0.66, '': 1.0};

    for (final entry in yLabels.entries) {
      final y = topPad + drawH * entry.value;

      if (entry.key == '') {
        canvas.drawLine(Offset(0, y), Offset(drawW, y), solidPaint);
      } else {
        _drawDottedLine(canvas, Offset(0, y), Offset(drawW, y), gridPaint);
      }
    }

    // Gradient Fill
    final fillPath = Path();
    fillPath.moveTo(pointAt(0).dx, size.height - botPad);
    fillPath.lineTo(pointAt(0).dx, pointAt(0).dy);

    for (int i = 1; i < points.length; i++) {
      fillPath.lineTo(pointAt(i).dx, pointAt(i).dy);
    }

    fillPath.lineTo(pointAt(points.length - 1).dx, size.height - botPad);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.accent.withValues(alpha: 0.45),
          AppColors.accent.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, topPad, drawW, drawH));

    canvas.drawPath(fillPath, fillPaint);

    //Main Line
    final linePaint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = points.length > 50 ? 1.0 : 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final linePath = Path();
    linePath.moveTo(pointAt(0).dx, pointAt(0).dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(pointAt(i).dx, pointAt(i).dy);
    }
    canvas.drawPath(linePath, linePaint);

    //  Dots (Only for small data sets)
    if (points.length < 10) {
      final dotFill = Paint()..color = Colors.white..style = PaintingStyle.fill;
      final dotBorder = Paint()
        ..color = AppColors.accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      for (int i = 0; i < points.length; i++) {
        final p = pointAt(i);
        canvas.drawCircle(p, 3.5, dotFill);
        canvas.drawCircle(p, 3.5, dotBorder);
      }
    }

    // Y-axis Labels
    for (final entry in yLabels.entries) {
      if (entry.key.isEmpty) continue;

      final y = topPad + drawH * entry.value;
      final tp = TextPainter(
        text: TextSpan(
          text: entry.key,
          style: TextStyle(
            fontFamily: _fontFamily,
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 9,
            fontWeight: FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(size.width - tp.width, y - tp.height / 2));
    }
  }

  // Dotted line helper
  void _drawDottedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 2.0;
    const dashSpace = 3.0;
    double distance = 0;
    final total = end.dx - start.dx;

    while (distance < total) {
      final x1 = start.dx + distance;
      final x2 = (x1 + dashWidth).clamp(start.dx, end.dx);
      canvas.drawLine(Offset(x1, start.dy), Offset(x2, start.dy), paint);
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(LinePainter old) => old.points != points;
}