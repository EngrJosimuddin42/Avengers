import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../themes/app_colors.dart';

class ProgressRow extends StatelessWidget {
  final String label;
  final double percentage;

  const ProgressRow({super.key, required this.label, required this.percentage});

  @override
  Widget build(BuildContext context) {
    const String customFont = 'TikTokSans';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: customFont,
                  color: AppColors.textPrimary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontFamily: customFont,
                  color: AppColors.textPrimary,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF474747)),
              minHeight: 10.h,
            ),
          ),
        ],
      ),
    );
  }
}