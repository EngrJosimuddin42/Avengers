import 'package:analytics_app/themes/dark_theme.dart';
import 'package:analytics_app/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'controllers/performance_controller.dart';
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
          theme: darkTheme(),
          initialBinding: BindingsBuilder(() {
            Get.put(AnalyticsController());
            Get.put(PerformanceController());
          }),
          home: const SplashScreen(),
        );
      },
    );
  }
}