import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/performance_controller.dart';
import '../../helpers/bar_chart_painter.dart';
import '../../themes/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class PerformanceScreen extends GetView<PerformanceController> {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Obx(() => Column(
          children: [
            const _PerformanceAppBar(),
            if (!controller.isOverview.value) const _RangeTabs(),
            Expanded(
              child: controller.isOverview.value
                  ? const _OverviewContent()
                  : const _ChartContent(),
            ),
          ],
        )),
      ),
    );
  }
}

//  AppBar
class _PerformanceAppBar extends GetView<PerformanceController> {
  const _PerformanceAppBar();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: controller.isOverview.value
                  ? () => Get.back()
                  : controller.goToOverview,
              child: Icon(Icons.arrow_back_ios_new,
                  color: AppColors.textPrimary, size: 18.r),
            ),
          ),
          Column(
            children: [
              Text('Performance',
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  )),
              Text('Last update: Feb 15',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                  )),
            ],
          ),
        ],
      ),
    ));
  }
}

// Overview
class _OverviewContent extends GetView<PerformanceController> {
  const _OverviewContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _RewardsCard(),
          SizedBox(height: 16.h),
          const _HighQualityVideosSection(),
          SizedBox(height: 16.h),
          const _RewardCriteriaSection(),
          SizedBox(height: 16.h),
          _ViewMoreButton(onTap: controller.goToChartScreen),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

//  Chart Content
class _ChartContent extends GetView<PerformanceController> {
  const _ChartContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CreatorRewardsCard(),
          SizedBox(height: 16.h),
          const _RewardsCard(),
          SizedBox(height: 16.h),
          const _HighQualityVideosSection(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

// ─── Range Tabs ───────────────────────────────────────────────────────────────
class _RangeTabs extends GetView<PerformanceController> {
  const _RangeTabs();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: controller.rangeTabs.asMap().entries.map((e) {
          final i          = e.key;
          final label      = e.value;
          final isSelected = controller.selectedRangeTab.value == i;
          final isCustom   = label == 'Custom';

          return GestureDetector(
            onTap: () => controller.selectRangeTab(i),
            child: Container(
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.textPrimary : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label,
                      style: TextStyle(
                        color: isSelected ? AppColors.bg : AppColors.textSecondary,
                        fontSize: 13.sp,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      )),
                  if (isCustom) ...[
                    SizedBox(width: 4.w),
                    Icon(Icons.keyboard_arrow_down,
                        color: AppColors.textSecondary, size: 14.r),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ));
  }
}

// ─── Creator Rewards Card ─────────────────────────────────────────────────────
class _CreatorRewardsCard extends GetView<PerformanceController> {
  const _CreatorRewardsCard();

  @override
  Widget build(BuildContext context) {
    return Obx(() => _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text('Creator Rewards',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(width: 6.w),
              Icon(Icons.info_outline, size: 14.r, color: AppColors.textSecondary),
              const Spacer(),
              GestureDetector(
                onTap: controller.previousMonth,
                child: Icon(Icons.chevron_left,
                    color: AppColors.textSecondary, size: 20.r),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(controller.currentMonth.value,
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 13.sp)),
              ),
              GestureDetector(
                onTap: controller.nextMonth,
                child: Icon(Icons.chevron_right,
                    color: AppColors.textSecondary, size: 20.r),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Amount
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('\$0.00',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                  )),
              if (controller.selectedRangeTab.value == 1) ...[
                SizedBox(width: 8.w),
                Icon(Icons.cloud_sync_outlined,
                    color: const Color(0xFF64B5F6), size: 16.r),
                SizedBox(width: 4.w),
                Text('\$0.00 (Feb 15)',
                    style: TextStyle(
                        color: const Color(0xFF64B5F6), fontSize: 11.sp)),
              ],
            ],
          ),
          SizedBox(height: 4.h),
          Text('Feb 16, 2025 - Feb 15, 2026',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11.sp)),
          SizedBox(height: 12.h),

          // ── Reward Entries — border সহ ────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.10),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              children: controller.rewardEntries.asMap().entries.map((e) {
                final i     = e.key;
                final entry = e.value;
                final isLast = i == controller.rewardEntries.length - 1;

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 11.h),
                      child: Row(
                        children: [
                          Container(
                            width: 7.r,
                            height: 7.r,
                            decoration: const BoxDecoration(
                              color: Color(0xFF64B5F6),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              entry.label,
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12.sp),
                            ),
                          ),
                          Text(
                            entry.amount,
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 12.h),
          // Bar chart
          SizedBox(
            height: 130.h,
            child: CustomPaint(
              painter: BarChartPainter(
                bars: controller.currentBars,
                barColor: const Color(0xFF607D8B),
                gridColor: Colors.white.withValues(alpha: 0.1),
                labelColor: const Color(0xFF757575),
                maxGridValue: 3,
              ),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    ));
  }
}

// ─── Rewards Card ─────────────────────────────────────────────────────────────
class _RewardsCard extends GetView<PerformanceController> {
  const _RewardsCard();

  @override
  Widget build(BuildContext context) {
    final r = controller.rewardsInfo;
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Rewards calculation',
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  )),
              SizedBox(width: 6.w),
              Icon(Icons.info_outline, size: 14.r, color: AppColors.textSecondary),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RewardMetric(label: 'Rewards', value: r.rewards),
              SizedBox(width: 24.w),
              _RewardMetric(label: 'RPM', value: r.rpm),
              SizedBox(width: 24.w),
              Expanded(
                child: _RewardMetric(
                  label: 'Qualified views',
                  value: r.qualifiedViews,
                  valueSmall: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(r.note,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11.sp)),
        ],
      ),
    );
  }
}

class _RewardMetric extends StatelessWidget {
  final String label;
  final String value;
  final bool valueSmall;

  const _RewardMetric({
    required this.label,
    required this.value,
    this.valueSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final isQualifiedViews = label == 'Qualified views';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 11.sp)),
        SizedBox(height: 2.h),
        Text(value,
            style: TextStyle(
              color: isQualifiedViews
                  ? AppColors.textSecondary
                  : AppColors.textPrimary,
              fontSize: valueSmall ? 12.sp : 16.sp,
              fontWeight: FontWeight.w600,
            )),
      ],
    );
  }
}

// ─── High Quality Videos ──────────────────────────────────────────────────────
class _HighQualityVideosSection extends GetView<PerformanceController> {
  const _HighQualityVideosSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Creating high-quality videos',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            )),
        SizedBox(height: 4.h),
        Text('Best practices to get the additional reward.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp)),
        SizedBox(height: 12.h),
        Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.criteriaTabs.asMap().entries.map((e) {
              final i          = e.key;
              final label      = e.value;
              final isSelected = controller.selectedCriteriaTab.value == i;
              return GestureDetector(
                onTap: () => controller.selectCriteriaTab(i),
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.textPrimary
                        : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(label,
                      style: TextStyle(
                        color: isSelected ? AppColors.bg : AppColors.textSecondary,
                        fontSize: 12.sp,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      )),
                ),
              );
            }).toList(),
          ),
        )),
        SizedBox(height: 12.h),
        SizedBox(
          height: 160.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.videos.length,
            itemBuilder: (_, i) {
              final v = controller.videos[i];
              return Container(
                width: 120.w,
                margin: EdgeInsets.only(right: 8.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.asset(
                    v.imagePath,
                    fit: BoxFit.fill,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF2A2A2A),
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── Reward Criteria ──────────────────────────────────────────────────────────
class _RewardCriteriaSection extends GetView<PerformanceController> {
  const _RewardCriteriaSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reward criteria',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            )),
        SizedBox(height: 12.h),
        _SectionCard(
          child: Column(
            children: controller.criteria.asMap().entries.map((e) {
              final i = e.key;
              final c = e.value;
              return Column(
                children: [
                  if (i != 0)
                    Divider(
                      color: Colors.white.withValues(alpha: 0.07),
                      height: 1,
                      thickness: 0.5,
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 32.r,
                          height: 32.r,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(Icons.sentiment_dissatisfied_outlined,
                              color: AppColors.textSecondary, size: 18.r),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.title,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                              SizedBox(height: 3.h),
                              Text(c.description,
                                  style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 11.sp)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ─── View More Button ─────────────────────────────────────────────────────────
class _ViewMoreButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ViewMoreButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2A2A2A),
          foregroundColor: AppColors.textPrimary,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r)),
          elevation: 0,
        ),
        child: Text('View more',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

// ─── Shared Card ──────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: child,
    );
  }
}