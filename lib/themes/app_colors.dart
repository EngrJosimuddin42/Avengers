import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  AppColors._();

  static const bg            = Color(0xFF0E0E0E);
  static const surface       = Color(0xFF212121);
  static const surface1       = Color(0xFF3B3B3B);
  static const card          = Color(0xFF222222);
  static const card1          = Color(0xFF34404B);
  static const accent        = Color(0xFF8ECAFF);
  static const divider       = Color(0xFF2A2A2A);
  static const textPrimary   = Colors.white;
  static const textPrimary1   = Color(0xFF8ECAFF);
  static const textSecondary = Color(0xFFFFFFFF);
  static const positive      = Color(0xFF8ECAFF);
  static const negative      = Colors.redAccent;
}

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get heading => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get sectionTitle => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get metricValue => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get metricLabel => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 11.sp,
  );

  static TextStyle get tabActive => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get tabInactive => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13.sp,
  );

  static TextStyle get rangeActive => TextStyle(
    color: Colors.black,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get rangeInactive => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get bodyPrimary => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 13.sp,
  );

  static TextStyle get bodySecondary => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13.sp,
  );

  static TextStyle get caption => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 11.sp,
  );

  static TextStyle get chartLabel => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 9.sp,
  );

  static TextStyle get changeText => TextStyle(fontSize: 10.sp);

  static TextStyle get dateLabel => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 10.sp,
  );
}