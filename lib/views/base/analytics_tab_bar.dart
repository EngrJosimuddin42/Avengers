import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../themes/app_colors.dart';
import '../../controllers/analytics_controller.dart';

class AnalyticsTabBar extends GetView<AnalyticsController> {
  const AnalyticsTabBar({super.key});

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