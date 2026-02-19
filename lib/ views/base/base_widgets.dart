import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../themes/app_colors.dart';

// Section Title
class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(Icons.info_outline, color: AppColors.textSecondary, size: 14.r),
          ],
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11.sp),
          ),
      ],
    );
  }
}

// Progress Row
class ProgressRow extends StatelessWidget {
  final String label;
  final double percentage;

  const ProgressRow({super.key, required this.label, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(color: AppColors.textPrimary, fontSize: 13.sp),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
              minHeight: 4.h,
            ),
          ),
        ],
      ),
    );
  }
}

// App Card Container
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const AppCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: child,
    );
  }
}