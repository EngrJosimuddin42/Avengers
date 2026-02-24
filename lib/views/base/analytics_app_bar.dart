import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../themes/app_colors.dart';

class AnalyticsAppBar extends StatelessWidget {
  const AnalyticsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios_new,
                color: AppColors.textPrimary, size: 20.r),
          ),
          Expanded(
            child: Center(
                child: Text('Analytics', style: AppTextStyles.heading)),
          ),
          SizedBox(width: 20.w),
        ],
      ),
    );
  }
}