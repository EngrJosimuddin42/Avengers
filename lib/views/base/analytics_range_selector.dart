import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../themes/app_colors.dart';
import '../../controllers/analytics_controller.dart';

class AnalyticsRangeSelector extends GetView<AnalyticsController> {
  const AnalyticsRangeSelector({super.key});

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
                  padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    r,
                    style: isSelected
                        ? AppTextStyles.rangeActive.copyWith(
                      color: Colors.black,
                    )
                        : AppTextStyles.rangeInactive.copyWith(
                      color: AppColors.textPrimary,
                    ),
                ),
                ),
              );
            }),
            // Custom Range Chip
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Text(
                    'Custom',
                    style: AppTextStyles.rangeInactive.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.textPrimary,
                    size: 14.r,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}