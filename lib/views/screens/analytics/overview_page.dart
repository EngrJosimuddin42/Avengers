import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/analytics_controller.dart';
import '../../../themes/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../base/app_card.dart';
import '../../base/date_graph_card.dart';
import '../../base/editable_metrics_grid.dart';
import '../../base/editable_progress_row.dart';
import '../../base/tappable_date_header.dart';

class OverviewPage extends GetView<AnalyticsController> {
  const OverviewPage({super.key});

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
          EditableMetricsGrid(
            metrics: controller.currentMetrics,
            listTarget: controller.currentListTarget,
          ),
          SizedBox(height: 12.h),
          DateGraphCard(
            points: controller.graphPointsFromMetrics,
            startDate: controller.graphStartDate,
            endDate: controller.graphEndDate,
            onStartSave: controller.updateStartDate,
            onEndSave: controller.updateEndDate,
          ),
          SizedBox(height: 20.h),

          // Traffic Source
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
                  ...controller.currentTrafficSources
                      .asMap()
                      .entries
                      .map((entry) {
                    final index = entry.key;
                    final source = entry.value;
                    return Column(
                      children: [
                        EditableProgressRow(
                          label: source.label,
                          percentage: source.percentage,
                          onSave: (newLabel, newPct) =>
                              controller.updateTrafficSource(
                                controller.is7Days,
                                index,
                                newLabel,
                                newPct,
                              ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),

          // Search Queries (7 days only)
          if (controller.is7Days) ...[
            SizedBox(height: 24.h),
            AppCard(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppConstants.sectionSearchQueries,
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
                    ...controller.searchQueries
                        .asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key;
                      final query = entry.value;
                      return Column(
                        children: [
                          EditableProgressRow(
                            label: query.label,
                            percentage: query.percentage,
                            onSave: (newLabel, newPct) =>
                                controller.updateSearchQuery(
                                    index, newLabel, newPct),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: 40.h),
        ],
      )),
    );
  }
}