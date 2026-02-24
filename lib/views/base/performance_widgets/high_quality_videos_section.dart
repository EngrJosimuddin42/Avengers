import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/performance_controller.dart';
import '../../../themes/app_colors.dart';

class HighQualityVideosSection extends GetView<PerformanceController> {
  const HighQualityVideosSection({super.key});


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
            style:
            TextStyle(color: AppColors.textSecondary, fontSize: 13.sp)),
        SizedBox(height: 12.h),
        Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.criteriaTabs.asMap().entries.map((e) {
              final i          = e.key;
              final label      = e.value;
              final isSelected =
                  controller.selectedCriteriaTab.value == i;
              return GestureDetector(
                onTap: () => controller.selectCriteriaTab(i),
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.textPrimary
                        : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(label,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.bg
                            : AppColors.textPrimary,
                        fontSize: 13.sp,
                        fontWeight: isSelected
                            ? FontWeight.w400
                            : FontWeight.w400,
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
                width: 110.w,
                margin: EdgeInsets.only(right: 8.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.asset(
                    v.imagePath,
                    fit: BoxFit.fill,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF2A2A2A),
                      child: const Icon(Icons.broken_image,
                          color: Colors.grey),
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
