import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/metric_card.dart';
import 'editable_metric_tile.dart';

class EditableMetricsGrid extends StatelessWidget {
  final List<MetricCard> metrics;
  final String listTarget;

  const EditableMetricsGrid({
    super.key,
    required this.metrics,
    required this.listTarget,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 8.w,
        childAspectRatio: 1.75,
      ),
      itemCount: metrics.length,
      itemBuilder: (_, i) => EditableMetricTile(
        metric: metrics[i],
        index: i,
        listTarget: listTarget,
        isHighlighted: i == 0,
      ),
    );
  }
}