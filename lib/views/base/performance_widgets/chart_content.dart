import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'creator_rewards_card.dart';
import 'high_quality_videos_section.dart';
import 'rewards_card.dart';

class ChartContent extends StatelessWidget {
  const ChartContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CreatorRewardsCard(),
          SizedBox(height: 16.h),
          const RewardsCard(),
          SizedBox(height: 16.h),
          const HighQualityVideosSection(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}