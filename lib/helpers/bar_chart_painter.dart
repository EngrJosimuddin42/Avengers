import 'package:flutter/material.dart';
import '../models/performance_models.dart';

class BarChartPainter extends CustomPainter {
  final List<ChartBar> bars;
  final Color barColor;
  final Color gridColor;
  final Color labelColor;
  final double maxGridValue;

  BarChartPainter({
    required this.bars,
    required this.barColor,
    required this.gridColor,
    required this.labelColor,
    this.maxGridValue = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final barPaint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill;

    const labelFontSize = 10.0;
    const rightLabelWidth = 24.0;
    const bottomPadding = 20.0;
    const topPadding = 8.0;

    final chartWidth  = size.width - rightLabelWidth;
    final chartHeight = size.height - bottomPadding - topPadding;

    // Grid lines & right labels (0, 1, 2, 3)
    final gridSteps = [3, 2, 1, 0];
    for (final step in gridSteps) {
      final y = topPadding + chartHeight * (1 - step / maxGridValue);
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), gridPaint);

      // Right label
      _drawText(
        canvas,
        '$step',
        Offset(chartWidth + 4, y - labelFontSize / 2),
        labelFontSize,
        labelColor,
      );
    }

    // Bars & bottom labels
    final barWidth   = chartWidth / bars.length;
    final barPadding = barWidth * 0.25;

    for (int i = 0; i < bars.length; i++) {
      final bar = bars[i];
      final x   = i * barWidth;
      final barH = chartHeight * bar.normalized;

      if (barH > 0) {
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x + barPadding,
            topPadding + chartHeight - barH,
            barWidth - barPadding * 2,
            barH,
          ),
          const Radius.circular(2),
        );
        canvas.drawRRect(rect, barPaint);
      }

      // Bottom label
      _drawText(
        canvas,
        bar.label,
        Offset(x + barPadding, size.height - labelFontSize - 2),
        labelFontSize,
        labelColor,
      );
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, double fontSize, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: fontSize),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(BarChartPainter old) =>
      old.bars != bars || old.barColor != barColor;
}