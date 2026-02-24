import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../themes/app_colors.dart';
import '../../controllers/analytics_controller.dart';
import '../../utils/app_constants.dart';

class TappableDateHeader extends GetView<AnalyticsController> {
  const TappableDateHeader({super.key});

  static Future<void> showDateDialog(
      BuildContext context,
      String current,
      void Function(String) onSave,
      ) async {
    final ctrl = TextEditingController(text: current);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r)),
        title: Text('Edit Date',
            style: TextStyle(
                color: AppColors.textPrimary, fontSize: 15.sp)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style:
          TextStyle(color: AppColors.textPrimary, fontSize: 14.sp),
          cursorColor: AppColors.accent,
          decoration: const InputDecoration(
            hintText: 'e.g. Feb 9',
            hintStyle: TextStyle(color: AppColors.textSecondary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.textSecondary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
              BorderSide(color: AppColors.accent, width: 1.5),
            ),
          ),
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ctrl.text),
            child: const Text('Save',
                style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      onSave(result.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppConstants.sectionKeyMetrics,
                style: AppTextStyles.heading),
            SizedBox(width: 6.w),
            Icon(
              Icons.info_outline,
              size: 14.r,
              color: AppColors.textSecondary,
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => showDateDialog(
                context,
                controller.graphStartDate,
                controller.updateStartDate,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 2.h, horizontal: 2.w),
                child: Text(controller.graphStartDate,
                    style: AppTextStyles.dateLabel),
              ),
            ),
            Text(' – ', style: AppTextStyles.dateLabel),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => showDateDialog(
                context,
                controller.graphEndDate,
                controller.updateEndDate,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 2.h, horizontal: 2.w),
                child: Text(controller.graphEndDate,
                    style: AppTextStyles.dateLabel),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}