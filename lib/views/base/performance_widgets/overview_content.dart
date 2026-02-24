import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/performance_controller.dart';
import 'high_quality_videos_section.dart';
import 'reward_criteria_section.dart';
import 'rewards_card.dart';
import 'view_more_button.dart';

class OverviewContent extends GetView<PerformanceController> {
  const OverviewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RewardsCard(),
          SizedBox(height: 16.h),
          const HighQualityVideosSection(),
          SizedBox(height: 16.h),
          const RewardCriteriaSection(),
          SizedBox(height: 16.h),
          ViewMoreButton(onTap: controller.goToChartScreen),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}