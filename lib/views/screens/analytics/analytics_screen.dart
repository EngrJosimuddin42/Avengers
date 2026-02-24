import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/analytics_controller.dart';
import '../../../themes/app_colors.dart';
import '../../base/analytics_app_bar.dart';
import '../../base/analytics_range_selector.dart';
import '../../base/analytics_tab_bar.dart';
import 'overview_page.dart';
import 'viewers_page.dart';

class AnalyticsScreen extends GetView<AnalyticsController> {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            const AnalyticsAppBar(),
            const AnalyticsTabBar(),
            const AnalyticsRangeSelector(),
            Expanded(
              child: Obx(() {
                if (controller.selectedTab.value == 'Viewers') {
                  return const ViewersPage();
                }
                return const OverviewPage();
              }),
            ),
          ],
        ),
      ),
    );
  }
}