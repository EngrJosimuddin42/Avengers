import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/analytics_controller.dart';
import '../../../themes/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../base/app_card.dart';
import '../../base/date_graph_card.dart';
import '../../base/donut_painter.dart';
import '../../base/gender_tab_row.dart';
import '../../base/inline_edit_number.dart';
import '../../base/inline_edit_text.dart';
import '../../base/tappable_date_header.dart';

class ViewersPage extends GetView<AnalyticsController> {
  const ViewersPage({super.key});

  Color _donutColor(String label) {
    switch (label) {
      case 'Male':
        return const Color(0xFF90CAF9);
      case 'Female':
        return const Color(0xFF455A64);
      default:
        return const Color(0xFF263238);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TappableDateHeader(),
          SizedBox(height: 12.h),

          // Viewer Metrics
          Row(
            children: List.generate(controller.metricsViewers.length, (i) {
              final m = controller.metricsViewers[i];
              final isFirst = i == 0;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: isFirst ? 8.w : 0),
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12.r),
                    border: isFirst
                        ? Border.all(color: AppColors.accent, width: 1.5)
                        : Border.all(color: AppColors.accent1, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(m.label,
                    style: AppTextStyles.metricLabel.copyWith(
                      color: AppColors.textPrimary)),
                      SizedBox(height: 4.h),
                      InlineEditText(
                        value: m.value,
                        style: AppTextStyles.metricValue,
                        onSave: (v) =>
                            controller.updateMetricValue('viewers', i, v),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 20.h),

          DateGraphCard(
            points: controller.graphPointsFromMetrics,
            startDate: controller.startDate365d.value,
            endDate: controller.endDate365d.value,
            onStartSave: (v) => controller.startDate365d.value = v,
            onEndSave: (v) => controller.endDate365d.value = v,
          ),
          SizedBox(height: 20.h),

          // Gender Distribution
          AppCard(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppConstants.sectionTrafficSource,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.info_outline,
                        size: 14.r,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  const GenderTabRow(),
                  SizedBox(height: 2.h),
                  SizedBox(
                    height: 100.h,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: DonutPainter(data: controller.genderData),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ...controller.genderData.asMap().entries.map((entry) {
                    final i = entry.key;
                    final g = entry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (i != 0)
                          Divider(
                            color: Colors.white.withValues(alpha: 0.08),
                            thickness: 0.5,
                            height: 0.5,
                          ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Row(
                            children: [
                              Container(
                                width: 8.r,
                                height: 8.r,
                                decoration: BoxDecoration(
                                  color: _donutColor(g.label),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  g.label,
                                  style: AppTextStyles.bodyPrimary,
                                ),
                              ),
                              InlineEditNumber(
                                value: g.percentage,
                                onSave: (v) =>
                                    controller.updateGenderPercentage(i, v),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      )),
    );
  }
}