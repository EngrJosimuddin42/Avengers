import 'package:analytics_app/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_selector_screen.dart';
import 'expire_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  DateTime now = DateTime.now();

  void isExpire() {
    debugPrint("now: $now");
    String expire = "2026-02-26 09:55:52.226818";
    if (now.isAfter(DateTime.parse(expire))) {
      Get.offAll(() => const ExpireScreen());
    } else {
      Get.to(() => const DashboardSelectorScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () => isExpire());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bg,
    );
  }
}
