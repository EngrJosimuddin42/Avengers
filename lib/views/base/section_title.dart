import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../themes/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    const String customFont = 'TikTokSans';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: customFont,
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
            style: TextStyle(
              fontFamily: customFont,
              color: AppColors.textSecondary,
              fontSize: 11.sp,
            ),
          ),
      ],
    );
  }
}