import 'package:flutter/material.dart';
import '../models/performance_models.dart';

class BarChartPainter extends CustomPainter {
  final List<ChartBar> bars;
  final Color barColor;
  final Color gridColor;
  final Color labelColor;
  final double maxGridValue;
  final int? selectedBarIndex;

  const BarChartPainter({
    required this.bars,
    required this.barColor,
    required this.gridColor,
    required this.labelColor,
    this.maxGridValue = 3,
    this.selectedBarIndex,
  });

  static const double _rightLabelWidth = 24.0;
  static const double _bottomPadding   = 20.0;
  static const double _topPadding      = 8.0;
  static const double _labelFontSize   = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    final double chartWidth  = size.width - _rightLabelWidth;
    final double chartHeight = size.height - _bottomPadding - _topPadding;
    _drawGrid(canvas, size, chartWidth, chartHeight);
    _drawBars(canvas, size, chartWidth, chartHeight);
  }

  void _drawGrid(Canvas canvas, Size size, double chartWidth, double chartHeight) {
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (int step = 0; step <= maxGridValue.toInt(); step++) {
      final double y = _topPadding + chartHeight * (1 - step / maxGridValue);
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), gridPaint);
      _drawText(canvas, '$step',
          Offset(chartWidth + 4, y - _labelFontSize / 2),
          _labelFontSize, labelColor);
    }
  }

  void _drawBars(Canvas canvas, Size size, double chartWidth, double chartHeight) {
    final double barWidth   = chartWidth / bars.length;
    final double barPadding = barWidth * 0.25;

    for (int i = 0; i < bars.length; i++) {
      final bar         = bars[i];
      final double x    = i * barWidth;
      final double barH = chartHeight * bar.normalized;
      final bool isSelected = selectedBarIndex == i;

      if (barH > 0) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              x + barPadding,
              _topPadding + chartHeight - barH,
              barWidth - barPadding * 2,
              barH,
            ),
            const Radius.circular(2),
          ),
          Paint()
            ..color = isSelected
                ? Colors.white.withValues(alpha: 0.85)
                : barColor
            ..style = PaintingStyle.fill,
        );
      }

      _drawText(canvas, bar.label,
          Offset(x + barPadding, size.height - _labelFontSize - 2),
          _labelFontSize, labelColor);
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset,
      double fontSize, Color color) {
    (TextPainter(
      text: TextSpan(
          text: text, style: TextStyle(color: color, fontSize: fontSize)),
      textDirection: TextDirection.ltr,
    )..layout())
        .paint(canvas, offset);
  }

  // Returns the bar index at the given dx, or null.
  int? getBarIndex(double dx, double totalWidth) {
    if (bars.isEmpty) return null;
    final double chartWidth = totalWidth - _rightLabelWidth;
    final double barAreaW   = chartWidth / bars.length;
    for (int i = 0; i < bars.length; i++) {
      if (dx >= i * barAreaW && dx < (i + 1) * barAreaW) return i;
    }
    return null;
  }

  @override
  bool shouldRepaint(BarChartPainter old) =>
      old.bars != bars ||
          old.barColor != barColor ||
          old.selectedBarIndex != selectedBarIndex;
}