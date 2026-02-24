import 'package:analytics_app/views/base/performance_widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/performance_controller.dart';
import '../../../themes/app_colors.dart';

class RewardCriteriaSection extends GetView<PerformanceController> {
  const RewardCriteriaSection({super.key});

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
        SectionCard(
          child: Column(
            children: controller.criteria.asMap().entries.map((e) {
              final i = e.key;
              final c = e.value;
              return Column(
                children: [
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
                          child: Icon(
                            Icons.sentiment_dissatisfied_outlined,
                            color: AppColors.textSecondary,
                            size: 18.r,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.title,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  )),
                              SizedBox(height: 3.h),
                              Text(c.description,
                                  style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13.sp)),
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

