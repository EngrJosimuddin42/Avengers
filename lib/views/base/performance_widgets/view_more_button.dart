import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../themes/app_colors.dart';

class ViewMoreButton extends StatelessWidget {
  final VoidCallback onTap;
  const ViewMoreButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2A2A2A),
          foregroundColor: AppColors.textPrimary,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r)),
          elevation: 0,
        ),
        child: Text('View more',
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400)),
      ),
    );
  }
}