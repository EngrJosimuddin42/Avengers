import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/performance_controller.dart';
import '../../helpers/bar_chart_painter.dart';
import '../../themes/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class _InlineEditText extends StatefulWidget {
  final String value;
  final TextStyle? style;
  final void Function(String) onSave;
  final int maxLength;
  final TextInputType keyboardType;

  const _InlineEditText({
    super.key,
    required this.value,
    required this.onSave,
    this.style,
    this.maxLength = 30,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<_InlineEditText> createState() => _InlineEditTextState();
}

class _InlineEditTextState extends State<_InlineEditText> {
  late TextEditingController _ctrl;
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value);
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    final isFocused = _focusNode.hasFocus;
    if (!isFocused) {
      final v = _ctrl.text.trim();
      if (v.isNotEmpty && v != widget.value) widget.onSave(v);
      if (_ctrl.text.trim().isEmpty) _ctrl.text = widget.value;
    }
    if (mounted) setState(() => _focused = isFocused);
  }

  @override
  void didUpdateWidget(_InlineEditText old) {
    super.didUpdateWidget(old);
    if (!_focusNode.hasFocus && old.value != widget.value) {
      _ctrl.text = widget.value;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _focused ? null : () {
        _focusNode.requestFocus();
      },
      child: IntrinsicWidth(
        child: TextField(
          controller: _ctrl,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          readOnly: !_focused,
          style: widget.style ?? TextStyle(color: AppColors.textPrimary, fontSize: 14.sp),
          cursorColor: _focused ? AppColors.accent : Colors.transparent,
          onSubmitted: (_) => _focusNode.unfocus(),
          onTapOutside: (_) => _focusNode.unfocus(),
          inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
          maxLines: null,
          minLines: 1,
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: _focused
                ? EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h)
                : EdgeInsets.zero,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
            ),
            filled: _focused,
            fillColor: AppColors.bg,
          ),
        ),
      ),
    );
  }
}


// Root Screen
class PerformanceScreen extends GetView<PerformanceController> {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Obx(() => Column(
          children: [
            const _PerformanceAppBar(),
            if (!controller.isOverview.value) const _RangeTabs(),
            Expanded(
              child: controller.isOverview.value
                  ? const _OverviewContent()
                  : const _ChartContent(),
            ),
          ],
        )),
      ),
    );
  }
}

// AppBar
class _PerformanceAppBar extends GetView<PerformanceController> {
  const _PerformanceAppBar();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: controller.isOverview.value
                  ? () => Get.back()
                  : controller.goToOverview,
              child: Icon(Icons.arrow_back_ios_new,
                  color: AppColors.textPrimary, size: 18.r),
            ),
          ),
          Column(
            children: [
              Text('Performance',
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  )),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Last update: ',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 12.sp,
                      )),
                  _InlineEditText(
                    key: const ValueKey('lastUpdateDate'),
                    value: controller.lastUpdateDate.value,
                    onSave: controller.updateLastUpdateDate,
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                    maxLength: 20,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

// Overview Content
class _OverviewContent extends GetView<PerformanceController> {
  const _OverviewContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _RewardsCard(),
          SizedBox(height: 16.h),
          const _HighQualityVideosSection(),
          SizedBox(height: 16.h),
          const _RewardCriteriaSection(),
          SizedBox(height: 16.h),
          _ViewMoreButton(onTap: controller.goToChartScreen),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

// Chart Content
class _ChartContent extends GetView<PerformanceController> {
  const _ChartContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CreatorRewardsCard(),
          SizedBox(height: 16.h),
          const _RewardsCard(),
          SizedBox(height: 16.h),
          const _HighQualityVideosSection(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

// Range Tabs
class _RangeTabs extends GetView<PerformanceController> {
  const _RangeTabs();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: controller.rangeTabs.asMap().entries.map((e) {
          final i          = e.key;
          final label      = e.value;
          final isSelected = controller.selectedRangeTab.value == i;
          final isCustom   = label == 'Custom';

          return GestureDetector(
            onTap: () => controller.selectRangeTab(i),
            child: Container(
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.textPrimary
                    : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.bg
                            : AppColors.textSecondary,
                        fontSize: 13.sp,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      )),
                  if (isCustom) ...[
                    SizedBox(width: 4.w),
                    Icon(Icons.keyboard_arrow_down,
                        color: AppColors.textSecondary, size: 14.r),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ));
  }
}

// Creator Rewards Card
class _CreatorRewardsCard extends GetView<PerformanceController> {
  const _CreatorRewardsCard();

  @override
  Widget build(BuildContext context) {
    return Obx(() => _SectionCard(
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
                    color: AppColors.textSecondary, size: 20.r),
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
              _InlineEditText(
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
                    color: const Color(0xFF64B5F6), size: 16.r),
                SizedBox(width: 4.w),
                _InlineEditText(
                  key: const ValueKey('pendingAmount'),
                  value: controller.pendingAmount.value,
                  onSave: controller.updatePendingAmount,
                  style: TextStyle(
                      color: const Color(0xFF64B5F6), fontSize: 11.sp),
                  maxLength: 15,
                ),
                Text(' (',
                    style: TextStyle(
                        color: const Color(0xFF64B5F6), fontSize: 11.sp)),
                _InlineEditText(
                  key: const ValueKey('pendingDate'),
                  value: controller.pendingDate.value,
                  onSave: controller.updatePendingDate,
                  style: TextStyle(
                      color: const Color(0xFF64B5F6), fontSize: 11.sp),
                  maxLength: 10,
                ),
                Text(')',
                    style: TextStyle(
                        color: const Color(0xFF64B5F6), fontSize: 11.sp)),
              ],
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _InlineEditText(
                key: const ValueKey('dateRangeStart'),
                value: controller.dateRangeStart.value,
                onSave: controller.updateDateRangeStart,
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 11.sp),
                maxLength: 20,
              ),
              Text(' - ',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 11.sp)),
              _InlineEditText(
                key: const ValueKey('dateRangeEnd'),
                value: controller.dateRangeEnd.value,
                onSave: controller.updateDateRangeEnd,
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 11.sp),
                maxLength: 20,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.10),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              children: controller.rewardEntries.asMap().entries.map((e) {
                final i     = e.key;
                final entry = e.value;

                return Column(
                  children: [
                    if (i != 0)
                      Divider(
                        color: Colors.white.withValues(alpha: 0.07),
                        height: 1,
                        thickness: 0.5,
                      ),
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
                          _InlineEditText(
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
          const _ChartWithTooltip(),
        ],
      ),
    ));
  }
}

// Chart with Tooltip
class _ChartWithTooltip extends GetView<PerformanceController> {
  const _ChartWithTooltip();

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
                  right: 30,
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
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500)),
                            Text(ttAmount,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
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
                                        fontSize: 11.sp)),
                              ]),
                              Text(entry.amount,
                                  style: TextStyle(
                                      color: Colors.white
                                          .withValues(alpha: 0.65),
                                      fontSize: 11.sp)),
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


// Rewards Card
class _RewardsCard extends GetView<PerformanceController> {
  const _RewardsCard();

  @override
  Widget build(BuildContext context) {
    return Obx(() => _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Rewards calculation',
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  )),
              SizedBox(width: 6.w),
              Icon(Icons.info_outline,
                  size: 14.r, color: AppColors.textSecondary),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rewards',
                      style: TextStyle(
                          color: AppColors.textPrimary, fontSize: 11.sp)),
                  SizedBox(height: 2.h),
                  _InlineEditText(
                    key: const ValueKey('rewardsValue'),
                    value: controller.rewardsValue.value,
                    onSave: controller.updateRewardsValue,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLength: 15,
                  ),
                ],
              ),
              SizedBox(width: 24.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RPM',
                      style: TextStyle(
                          color: AppColors.textPrimary, fontSize: 11.sp)),
                  SizedBox(height: 2.h),
                  _InlineEditText(
                    key: const ValueKey('rewardsRpm'),
                    value: controller.rewardsRpm.value,
                    onSave: controller.updateRewardsRpm,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLength: 15,
                  ),
                ],
              ),
              SizedBox(width: 24.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Qualified views',
                        style: TextStyle(
                            color: AppColors.textPrimary, fontSize: 11.sp)),
                    SizedBox(height: 2.h),
                    _InlineEditText(
                      key: const ValueKey('rewardsQualifiedViews'),
                      value: controller.rewardsQualifiedViews.value,
                      onSave: controller.updateRewardsQualifiedViews,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLength: 25,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _InlineEditText(
            key: const ValueKey('rewardsNote'),
            value: controller.rewardsNote.value,
            onSave: controller.updateRewardsNote,
            style: TextStyle(
                color: AppColors.textSecondary, fontSize: 11.sp),
            maxLength: 120,
            keyboardType: TextInputType.multiline,
          ),
        ],
      ),
    ));
  }
}


// High Quality Videos Section
class _HighQualityVideosSection extends GetView<PerformanceController> {
  const _HighQualityVideosSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Creating high-quality videos',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            )),
        SizedBox(height: 4.h),
        Text('Best practices to get the additional reward.',
            style:
            TextStyle(color: AppColors.textSecondary, fontSize: 12.sp)),
        SizedBox(height: 12.h),
        Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.criteriaTabs.asMap().entries.map((e) {
              final i          = e.key;
              final label      = e.value;
              final isSelected =
                  controller.selectedCriteriaTab.value == i;
              return GestureDetector(
                onTap: () => controller.selectCriteriaTab(i),
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.textPrimary
                        : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(label,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.bg
                            : AppColors.textSecondary,
                        fontSize: 12.sp,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      )),
                ),
              );
            }).toList(),
          ),
        )),
        SizedBox(height: 12.h),
        SizedBox(
          height: 160.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.videos.length,
            itemBuilder: (_, i) {
              final v = controller.videos[i];
              return Container(
                width: 110.w,
                margin: EdgeInsets.only(right: 8.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.asset(
                    v.imagePath,
                    fit: BoxFit.fill,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF2A2A2A),
                      child: const Icon(Icons.broken_image,
                          color: Colors.grey),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


// Reward Criteria Section
class _RewardCriteriaSection extends GetView<PerformanceController> {
  const _RewardCriteriaSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reward criteria',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            )),
        SizedBox(height: 12.h),
        _SectionCard(
          child: Column(
            children: controller.criteria.asMap().entries.map((e) {
              final i = e.key;
              final c = e.value;
              return Column(
                children: [
                  if (i != 0)
                    Divider(
                      color: Colors.white.withValues(alpha: 0.07),
                      height: 1,
                      thickness: 0.5,
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 32.r,
                          height: 32.r,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.sentiment_dissatisfied_outlined,
                            color: AppColors.textSecondary,
                            size: 18.r,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.title,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                              SizedBox(height: 3.h),
                              Text(c.description,
                                  style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 11.sp)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}


// View More Button
class _ViewMoreButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ViewMoreButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2A2A2A),
          foregroundColor: AppColors.textPrimary,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r)),
          elevation: 0,
        ),
        child: Text('View more',
            style:
            TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

// Shared Card
class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: child,
    );
  }
}