import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../themes/app_colors.dart';
import '../../controllers/analytics_controller.dart';

class GenderTabRow extends GetView<AnalyticsController> {
  const GenderTabRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      mainAxisSize: MainAxisSize.min,
      children: controller.genderTabs.map((tab) {
        final isSelected =
            controller.selectedGenderTab.value == tab;
        return GestureDetector(
          onTap: () => controller.selectGenderTab(tab),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(right: 8.w),
            padding: EdgeInsets.symmetric(
                horizontal: 16.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.card1
                  : AppColors.surface1,
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