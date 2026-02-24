import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../themes/app_colors.dart';
import '../../controllers/analytics_controller.dart';
import '../../models/metric_card.dart';
import 'inline_edit_text.dart';
import 'editable_change_row.dart';

class EditableMetricTile extends StatelessWidget {
  final MetricCard metric;
  final int index;
  final String listTarget;
  final bool isHighlighted;

  const EditableMetricTile({
    super.key,
    required this.metric,
    required this.index,
    required this.listTarget,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AnalyticsController>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8.r),
        border: isHighlighted
            ? Border.all(color: AppColors.accent, width: 1.5)
            : Border.all(color: AppColors.accent1, width: 1),
      ),
      child: OverflowBox(
        alignment: Alignment.topLeft,
        maxHeight: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              metric.label,
              style: AppTextStyles.metricLabel.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 2.h),
            InlineEditText(
              value: metric.value,
              style: AppTextStyles.metricValue,
              onSave: (v) => c.updateMetricValue(listTarget, index, v),
            ),
            SizedBox(height: 2.h),
            if (metric.change != null)
              EditableChangeRow(
                change: metric.change!,
                isPositive: metric.isPositive,
                onSave: (v) =>
                    c.updateMetricChange(listTarget, index, v),
              ),
          ],
        ),
      ),
    );
  }
}