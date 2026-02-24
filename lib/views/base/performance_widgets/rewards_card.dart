import 'package:analytics_app/views/base/performance_widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/performance_controller.dart';
import '../../../themes/app_colors.dart';
import '../inline_edit_text.dart';

class RewardsCard extends GetView<PerformanceController> {
  const RewardsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Rewards calculation',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  )),
              SizedBox(width: 6.w),
              Icon(Icons.info_outline,
                  size: 14.r, color: AppColors.textSecondary),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rewards',
                      style: TextStyle(
                          color: AppColors.textPrimary, fontSize: 13.sp)),
                  SizedBox(height: 2.h),
                  InlineEditText(
                    key: const ValueKey('rewardsValue'),
                    value: controller.rewardsValue.value,
                    onSave: controller.updateRewardsValue,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLength: 15,
                  ),
                ],
              ),
              SizedBox(width: 24.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RPM',
                      style: TextStyle(
                          color: AppColors.textPrimary, fontSize: 13.sp)),
                  SizedBox(height: 2.h),
                  InlineEditText(
                    key: const ValueKey('rewardsRpm'),
                    value: controller.rewardsRpm.value,
                    onSave: controller.updateRewardsRpm,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLength: 15,
                  ),
                ],
              ),
              SizedBox(width: 24.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Qualified views',
                        style: TextStyle(
                            color: AppColors.textPrimary, fontSize: 13.sp)),
                    SizedBox(height: 2.h),
                    InlineEditText(
                      key: const ValueKey('rewardsQualifiedViews'),
                      value: controller.rewardsQualifiedViews.value,
                      onSave: controller.updateRewardsQualifiedViews,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLength: 25,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Divider(
            color: Colors.white.withValues(alpha: 0.07),
            height: 1,
            thickness: 0.5,
          ),
          SizedBox(height: 10.h),
          InlineEditText(
            key: const ValueKey('rewardsNote'),
            value: controller.rewardsNote.value,
            onSave: controller.updateRewardsNote,
            style: TextStyle(
                color: AppColors.textSecondary, fontSize: 12.sp),
            maxLength: 120,
            keyboardType: TextInputType.multiline,
          ),
        ],
      ),
    ));
  }
}
