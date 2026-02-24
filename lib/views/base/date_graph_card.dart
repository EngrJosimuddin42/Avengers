import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../themes/app_colors.dart';
import '../../helpers/line_painter.dart';
import 'app_card.dart';
import 'tappable_date_header.dart';

class DateGraphCard extends StatelessWidget {
  final List<double> points;
  final String startDate;
  final String endDate;
  final void Function(String) onStartSave;
  final void Function(String) onEndSave;

  const DateGraphCard({
    super.key,
    required this.points,
    required this.startDate,
    required this.endDate,
    required this.onStartSave,
    required this.onEndSave,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: SizedBox(
        height: 160.h,
        child: CustomPaint(
          painter: LinePainter(points: points),
          child: Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Transform.translate(
                  offset: Offset(0, 18.h),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => TappableDateHeader.showDateDialog(
                            context, startDate, onStartSave),
                        child: Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Text(startDate,
                              style: AppTextStyles.dateLabel),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => TappableDateHeader.showDateDialog(
                            context, endDate, onEndSave),
                        child: Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Text(endDate,
                              style: AppTextStyles.dateLabel),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}