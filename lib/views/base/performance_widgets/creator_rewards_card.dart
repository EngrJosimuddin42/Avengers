import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/performance_controller.dart';
import '../../../themes/app_colors.dart';
import '../inline_edit_text.dart';
import 'chart_with_tooltip.dart';
import 'section_card.dart';

class CreatorRewardsCard extends GetView<PerformanceController> {
  const CreatorRewardsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Creator Rewards',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(width: 6.w),
              Icon(Icons.info_outline,
                  size: 14.r, color: AppColors.textSecondary),
              const Spacer(),
              GestureDetector(
                onTap: controller.previousMonth,
                child: Icon(Icons.chevron_left,
                    color: AppColors.textPrimary, size: 20.r),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  controller.currentMonth.value,
                  style: TextStyle(
                      color: AppColors.textPrimary, fontSize: 13.sp),
                ),
              ),
              GestureDetector(
                onTap: controller.nextMonth,
                child: Icon(Icons.chevron_right,
                    color: AppColors.textSecondary, size: 20.r),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InlineEditText(
                key: const ValueKey('totalAmount'),
                value: controller.currentTotalAmount,
                onSave: controller.updateTotalAmount,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                ),
                keyboardType: TextInputType.text,
                maxLength: 15,
              ),
              if (controller.selectedRangeTab.value == 1) ...[
                SizedBox(width: 8.w),
                Icon(Icons.cloud_sync_outlined,
                    color: const Color(0xFF0075DB), size: 16.r),
                SizedBox(width: 4.w),
                InlineEditText(
                  key: const ValueKey('pendingAmount'),
                  value: controller.pendingAmount.value,
                  onSave: controller.updatePendingAmount,
                  style: TextStyle(
                      color: const Color(0xFF0075DB), fontSize: 12.sp),
                  maxLength: 15,
                ),
                Text(' (',
                    style: TextStyle(
                        color: const Color(0xFF64B5F6), fontSize: 12.sp)),
                InlineEditText(
                  key: const ValueKey('pendingDate'),
                  value: controller.pendingDate.value,
                  onSave: controller.updatePendingDate,
                  style: TextStyle(
                      color: const Color(0xFF777A7C), fontSize: 12.sp),
                  maxLength: 10,
                ),
                Text(')',
                    style: TextStyle(
                        color: const Color(0xFF777A7C), fontSize: 12.sp)),
              ],
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InlineEditText(
                key: const ValueKey('dateRangeStart'),
                value: controller.dateRangeStart.value,
                onSave: controller.updateDateRangeStart,
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 12.sp),
                maxLength: 20,
              ),
              Text(' - ',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 12.sp)),
              InlineEditText(
                key: const ValueKey('dateRangeEnd'),
                value: controller.dateRangeEnd.value,
                onSave: controller.updateDateRangeEnd,
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 12.sp),
                maxLength: 20,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.10),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              children: controller.rewardEntries.asMap().entries.map((e) {
                final i     = e.key;
                final entry = e.value;

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 11.h),
                      child: Row(
                        children: [
                          Container(
                            width: 7.r,
                            height: 7.r,
                            decoration: const BoxDecoration(
                              color: Color(0xFF64B5F6),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              entry.label,
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12.sp),
                            ),
                          ),
                          InlineEditText(
                            key: ValueKey('rewardEntry_$i'),
                            value: entry.amount,
                            onSave: (v) =>
                                controller.updateRewardEntryAmount(i, v),
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12.sp),
                            maxLength: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 12.h),
          const ChartWithTooltip(),
        ],
      ),
    ));
  }
}
