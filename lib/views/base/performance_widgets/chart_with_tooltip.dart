import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/performance_controller.dart';
import '../../../helpers/bar_chart_painter.dart';

class ChartWithTooltip extends GetView<PerformanceController> {
  const ChartWithTooltip({super.key});


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int?>(
      valueListenable: controller.barSelection,
      builder: (_, selectedIdx, __) {
        final currentMonth = controller.currentMonth.value;
        final currentTab   = controller.selectedRangeTab.value;
        final bars         = controller.currentBars;
        final hasTooltip   = selectedIdx != null && selectedIdx < bars.length;

        String ttTitle  = '';
        String ttAmount = '\$0.00';
        if (hasTooltip) {
          final bar  = bars[selectedIdx];
          final year = currentMonth.split(' ').last;
          ttTitle  = currentTab == 1
              ? '${currentMonth.split(' ').first} ${bar.label}'
              : '${bar.label} $year';
          ttAmount = '\$${bar.value.toStringAsFixed(2)}';
        }

        return SizedBox(
          height: 130.h,
          child: Stack(
            children: [
              // Chart
              LayoutBuilder(builder: (_, constraints) {
                final painter = BarChartPainter(
                  bars: bars,
                  barColor: const Color(0xFF607D8B),
                  gridColor: Colors.white.withValues(alpha: 0.1),
                  labelColor: const Color(0xFF757575),
                  maxGridValue: 3,
                  selectedBarIndex: selectedIdx,
                );
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (d) {
                    final idx = painter.getBarIndex(
                      d.localPosition.dx,
                      constraints.maxWidth,
                    );
                    controller.onBarTap(idx);
                  },
                  child: CustomPaint(painter: painter, size: Size.infinite),
                );
              }),

              // Tooltip overlay
              if (hasTooltip)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 150,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(ttTitle,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500)),
                            Text(ttAmount,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Divider(
                            color: Colors.white.withValues(alpha: 0.12),
                            height: 1,
                            thickness: 0.5),
                        SizedBox(height: 6.h),
                        ...controller.rewardEntries.map((entry) => Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Container(
                                  width: 7.r,
                                  height: 7.r,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF64B5F6),
                                      shape: BoxShape.circle),
                                ),
                                SizedBox(width: 8.w),
                                Text(entry.label,
                                    style: TextStyle(
                                        color: Colors.white
                                            .withValues(alpha: 0.65),
                                        fontSize: 12.sp)),
                              ]),
                              Text(entry.amount,
                                  style: TextStyle(
                                      color: Colors.white
                                          .withValues(alpha: 0.65),
                                      fontSize: 12.sp)),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
