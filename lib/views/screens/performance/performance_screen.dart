import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/performance_controller.dart';
import '../../../themes/app_colors.dart';
import '../../base/performance_widgets/chart_content.dart';
import '../../base/performance_widgets/overview_content.dart';
import '../../base/performance_widgets/performance_app_bar.dart';
import '../../base/performance_widgets/range_tabs.dart';

class PerformanceScreen extends GetView<PerformanceController> {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Obx(() => Column(
          children: [
            const PerformanceAppBar(),
            if (!controller.isOverview.value) const RangeTabs(),
            Expanded(
              child: controller.isOverview.value
                  ? const OverviewContent()
                  : const ChartContent(),
            ),
          ],
        )),
      ),
    );
  }
}