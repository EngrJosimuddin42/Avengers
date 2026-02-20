import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import ' views/screens/dashboard_selector_screen.dart';
import 'controllers/performance_controller.dart';
import 'themes/app_colors.dart';
import 'controllers/analytics_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Creator Dashboard',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: AppColors.bg,
          ),
          initialBinding: BindingsBuilder(() {
            Get.put(AnalyticsController());
            Get.put(PerformanceController());
          }),
          home: const DashboardSelectorScreen(),
        );
      },
      child: const DashboardSelectorScreen(),
    );
  }
}