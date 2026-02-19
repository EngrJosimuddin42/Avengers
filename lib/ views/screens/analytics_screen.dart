import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../base/base_widgets.dart';
import '../../helpers/line_painter.dart';
import '../../themes/app_colors.dart';
import '../../controllers/analytics_controller.dart';
import '../../utils/app_constants.dart';
import '../../models/metric_card.dart';

class AnalyticsScreen extends GetView<AnalyticsController> {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            const _AppBar(),
            const _TabBar(),
            const _RangeSelector(),
            Expanded(
              child: Obx(() {
                if (controller.selectedTab.value == 'Viewers') {
                  return const _ViewersContent();
                }
                return const _OverviewContent();
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// Overview Content
class _OverviewContent extends GetView<AnalyticsController> {
  const _OverviewContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: AppConstants.sectionKeyMetrics,
            subtitle: controller.dateRange,
          ),
          SizedBox(height: 12.h),
          _MetricsGrid(metrics: controller.currentMetrics),
          SizedBox(height: 12.h),
          _GraphCard(
            points: controller.currentGraphPoints.toList(),
            startDate: controller.graphStartDate,
            endDate: controller.graphEndDate,
          ),
          SizedBox(height: 20.h),
          const SectionTitle(title: AppConstants.sectionTrafficSource),
          SizedBox(height: 12.h),
          AppCard(
            child: Column(
              children: controller.currentTrafficSources
                  .map((src) => ProgressRow(
                label: src.label,
                percentage: src.percentage,
              ))
                  .toList(),
            ),
          ),
          if (controller.is7Days) ...[
            SizedBox(height: 20.h),
            const SectionTitle(title: AppConstants.sectionSearchQueries),
            SizedBox(height: 12.h),
            AppCard(
              child: Column(
                children: controller.searchQueries
                    .map((q) => ProgressRow(
                  label: q.label,
                  percentage: q.percentage,
                ))
                    .toList(),
              ),
            ),
          ],
          SizedBox(height: 40.h),
        ],
      )),
    );
  }
}

// Viewers Content
class _ViewersContent extends GetView<AnalyticsController> {
  const _ViewersContent();

  Color _donutColor(String label) {
    switch (label) {
      case 'Male':   return const Color(0xFF90CAF9);
      case 'Female': return const Color(0xFF455A64);
      default:       return const Color(0xFF263238);
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

          // Key metrics
          SectionTitle(
            title: AppConstants.sectionKeyMetrics,
            subtitle: controller.dateRange,
          ),
          SizedBox(height: 12.h),
          Row(
            children: controller.metricsViewers.map((m) {
              final isFirst = m == controller.metricsViewers.first;
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
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(m.label, style: AppTextStyles.metricLabel),
                      SizedBox(height: 4.h),
                      Text(m.value, style: AppTextStyles.metricValue),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20.h),

          // Graph
          _GraphCard(
            points: controller.graphPoints365d.toList(),
            startDate: 'Feb 16, 2025',
            endDate: 'Feb 15, 2026',
          ),
          SizedBox(height: 20.h),


          //  Traffic Source
          AppCard(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Title row
                  Row(
                    children: [
                      Text(AppConstants.sectionTrafficSource,
                          style: TextStyle(color: AppColors.textPrimary, fontSize: 15.sp, fontWeight: FontWeight.w600)),
                      SizedBox(width: 6.w),
                      Icon(Icons.info_outline,
                          size: 14.r, color: AppColors.textSecondary),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Gender / Age / Locations tabs
                  const _GenderTabRow(),
                  SizedBox(height: 48.h),
                  // Semicircle donut chart
                  SizedBox(
                    height: 130.h,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: _DonutPainter(
                        data: controller.genderData,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Legend rows
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
                                child: Text(g.label,
                                    style: AppTextStyles.bodyPrimary),
                              ),
                              Text('${g.percentage.toInt()}%',
                                  style: AppTextStyles.bodySecondary),
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


// Gender Tab Row
class _GenderTabRow extends GetView<AnalyticsController> {
  const _GenderTabRow();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      mainAxisSize: MainAxisSize.min,
      children: controller.genderTabs.map((tab) {
        final isSelected = controller.selectedGenderTab.value == tab;
        return GestureDetector(
          onTap: () => controller.selectGenderTab(tab),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(right: 8.w),
            padding: EdgeInsets.symmetric(
                horizontal: 16.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.card1 : AppColors.surface1,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              tab,
              style: TextStyle(
                color: isSelected
                    ? AppColors.textPrimary1
                    : AppColors.textSecondary,
                fontSize: 13.sp,
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    ));
  }
}


// Donut Painter (Semicircle)
class _DonutPainter extends CustomPainter {
  final List<dynamic> data;
  _DonutPainter({required this.data});

  static const colors = [
    Color(0xFF90CAF9),
    Color(0xFF455A64),
    Color(0xFF263238),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final total  = data.fold<double>(0, (s, e) => s + e.percentage);
    final cx     = size.width / 2;
    final cy     = size.height * 0.95;
    final radius = size.width * 0.40;
    final stroke = radius * 0.50;

    final paint = Paint()
      ..style      = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap  = StrokeCap.butt;

    double startAngle = math.pi;
    const sweepTotal  = math.pi;

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
  bool shouldRepaint(_DonutPainter old) => false;
}


// Metrics Grid
class _MetricsGrid extends StatelessWidget {
  final List<MetricCard> metrics;
  const _MetricsGrid({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 8.w,
        childAspectRatio: 1.9,
      ),
      itemCount: metrics.length,
      itemBuilder: (_, i) => _MetricTile(
        metric: metrics[i],
        isHighlighted: i == 0,
      ),
    );
  }
}


// Metric Tile
class _MetricTile extends StatelessWidget {
  final MetricCard metric;
  final bool isHighlighted;

  const _MetricTile({
    required this.metric,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
        border: isHighlighted
            ? Border.all(color: AppColors.accent, width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(metric.label, style: AppTextStyles.metricLabel),
          SizedBox(height: 3.h),
          Text(metric.value, style: AppTextStyles.metricValue),
          SizedBox(height: 2.h),
          if (metric.change != null)
            _ChangeRow(
              change: metric.change!,
              isPositive: metric.isPositive,
            ),
        ],
      ),
    );
  }
}


// Change Row
class _ChangeRow extends StatelessWidget {
  final String change;
  final bool? isPositive;

  const _ChangeRow({required this.change, this.isPositive});

  @override
  Widget build(BuildContext context) {
    if (change == '0') {
      return Text('0',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 10.sp));
    }
    if (change.startsWith('+\$') || change.startsWith('-\$')) {
      return Text(change,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 10.sp));
    }

    final color = isPositive == true ? AppColors.accent : AppColors.textSecondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive == true
              ? Icons.cloud_upload_outlined
              : Icons.cloud_download_outlined,
          color: color,
          size: 11.r,
        ),
        SizedBox(width: 3.w),
        Flexible(
          child: Text(
            change,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color, fontSize: 10.sp),
          ),
        ),
      ],
    );
  }
}


// Graph Card
class _GraphCard extends StatelessWidget {
  final List<double> points;
  final String startDate;
  final String endDate;

  const _GraphCard({
    required this.points,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: SizedBox(
        height: 160.h,
        child: CustomPaint(
          painter: LinePainter(points: points),
          child: Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(startDate, style: AppTextStyles.dateLabel),
                    Text(endDate,   style: AppTextStyles.dateLabel),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// App Bar
class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios_new,
                color: AppColors.textPrimary, size: 20.r),
          ),
          Expanded(
            child: Center(
                child: Text('Analytics', style: AppTextStyles.heading)),
          ),
          SizedBox(width: 20.w),
        ],
      ),
    );
  }
}

// Tab Bar
class _TabBar extends GetView<AnalyticsController> {
  const _TabBar();

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: controller.tabs.map((tab) {
          final isSelected = controller.selectedTab.value == tab;
          return GestureDetector(
            onTap: () => controller.selectTab(tab),
            child: Container(
              margin: EdgeInsets.only(right: 24.w),
              padding: EdgeInsets.only(bottom: 8.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? AppColors.textPrimary
                        : Colors.transparent,
                    width: 2.h,
                  ),
                ),
              ),
              child: Text(tab,
                  style: isSelected
                      ? AppTextStyles.tabActive
                      : AppTextStyles.tabInactive),
            ),
          );
        }).toList(),
      ),
    ));
  }
}


// Range Selector
class _RangeSelector extends GetView<AnalyticsController> {
  const _RangeSelector();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...controller.ranges.take(4).map((r) {
              final isSelected = controller.selectedRange.value == r;
              return GestureDetector(
                onTap: () => controller.selectRange(r),
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(r,
                      style: isSelected
                          ? AppTextStyles.rangeActive
                          : AppTextStyles.rangeInactive),
                ),
              );
            }),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Text('Custom', style: AppTextStyles.rangeInactive),
                  SizedBox(width: 4.w),
                  Icon(Icons.keyboard_arrow_down,
                      color: AppColors.textSecondary, size: 14.r),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}