import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/performance_controller.dart';
import '../../../themes/app_colors.dart';

class RangeTabs extends GetView<PerformanceController> {
  const RangeTabs({super.key});

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
                color: isSelected
                    ? AppColors.textPrimary
                    : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.bg
                            : AppColors.textPrimary,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                      )),
                  if (isCustom) ...[
                    SizedBox(width: 4.w),
                    Icon(Icons.keyboard_arrow_down,
                        color: AppColors.textPrimary, size: 14.r),
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