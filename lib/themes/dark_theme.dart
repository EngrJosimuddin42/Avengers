import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData darkTheme({Color primaryColor = AppColors.accent}) => ThemeData(
  useMaterial3: true,
  fontFamily: 'TikTokSans',
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: AppColors.bg,
  cardColor: AppColors.card,
  dividerColor: AppColors.divider,


  colorScheme: ColorScheme.dark(
    primary: primaryColor,
    secondary: primaryColor,
    surface: AppColors.bg,
    error: const Color(0xFFDD3135),
    onPrimary: Colors.black,
    onSurface: AppColors.textPrimary,
  ),

  // Text Selection Theme (Pointer color)
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: primaryColor,
    selectionColor: primaryColor.withValues(alpha: 0.3),
    selectionHandleColor: primaryColor,
  ),

  // Text Button Theme
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryColor,
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),

  // Card Theme
  cardTheme: CardThemeData(
    color: AppColors.card,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),

  // Input Decoration (Text Field design)
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    hintStyle: const TextStyle(color: AppColors.textSecondary),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
);