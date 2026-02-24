import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  AppColors._();

  static const bg            = Colors.black;
  static const surface       = Color(0xFF212121);
  static const surface1      = Color(0xFF3B3B3B);
  static const card          = Color(0xFF222222);
  static const card1         = Color(0xFF34404B);
  static const accent        = Color(0xFF0075DB);
  static const accent1        = Color(0xFF6E6E6E);
  static const divider       = Color(0xFF2A2A2A);
  static const textPrimary   = Colors.white;
  static const textPrimary1  = Color(0xFF8ECAFF);
  static const textSecondary = Color(0xFF707070);
  static const positive      = Color(0xFF8ECAFF);
  static const negative      = Colors.redAccent;
}

class AppTextStyles {
  AppTextStyles._();

  // TikTok Sans font name
  static const String _fontFamily = 'TikTokSans';

  // Helper method for consistency
  static TextStyle _baseStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle get heading => _baseStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get sectionTitle => _baseStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get metricValue => _baseStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get metricLabel => _baseStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get tabActive => _baseStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get tabInactive => _baseStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get rangeActive => _baseStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static TextStyle get rangeInactive => _baseStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static TextStyle get bodyPrimary => _baseStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodySecondary => _baseStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get caption => _baseStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get chartLabel => _baseStyle(
    fontSize: 9.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get changeText => _baseStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.positive,
  );

  static TextStyle get dateLabel => _baseStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
}