
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/performance_controller.dart';
import '../../../themes/app_colors.dart';
import '../inline_edit_text.dart';

class PerformanceAppBar extends GetView<PerformanceController> {
  const PerformanceAppBar({super.key});

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
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  )),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Last update: ',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15.sp,
                      )),
                  Flexible(
                    child: InlineEditText(
                      key: const ValueKey('lastUpdateDate'),
                      value: controller.lastUpdateDate.value,
                      onSave: controller.updateLastUpdateDate,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15.sp,
                      ),
                      maxLength: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
