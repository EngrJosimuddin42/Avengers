import 'package:analytics_app/themes/app_colors.dart';
import 'package:flutter/material.dart';

class ExpireScreen extends StatelessWidget {
  const ExpireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
          child: Center(
              child: Text(
        'Your session has expired due to inactivity.\nPlease log in again to continue.',
        style: AppTextStyles.heading,
      ))),
    );
  }
}
