import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../themes/app_colors.dart';
import '../base/dashboard_option_card.dart';
import 'analytics/analytics_screen.dart';
import 'performance_screen.dart';

class DashboardSelectorScreen extends StatelessWidget {
  const DashboardSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Text(
                "Creator Dashboard",
                style: AppTextStyles.heading.copyWith(fontSize: 28.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                "Track your growth & earnings",
                style: AppTextStyles.bodySecondary.copyWith(fontSize: 15.sp),
              ),

              const Spacer(),

              //  Analytics Card
              DashboardOptionCard(
                title: "Analytics",
                subtitle: "Views • Traffic • Audience • Search",
                icon: Icons.analytics_rounded,
                accentColor: const Color(0xFF42A5F5),
                onTap: () => Get.to(() => const AnalyticsScreen()),
              ),

              SizedBox(height: 24.h),

              // Performance Card
              DashboardOptionCard(
                title: "Performance",
                subtitle: "Rewards • RPM • Qualified views",
                icon: Icons.trending_up_rounded,
                accentColor: const Color(0xFF26A69A),
                onTap: () => Get.to(() => const PerformanceScreen()),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}