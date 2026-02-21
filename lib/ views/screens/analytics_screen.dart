import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../base/base_widgets.dart';
import '../../helpers/line_painter.dart';
import '../../themes/app_colors.dart';
import '../../controllers/analytics_controller.dart';
import '../../utils/app_constants.dart';
import '../../models/metric_card.dart';


class AnalyticsScreen extends GetView<AnalyticsController> {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            const _AppBar(),
            const _TabBar(),
            const _RangeSelector(),
            Expanded(
              child: Obx(() {
                if (controller.selectedTab.value == 'Viewers') {
                  return const _ViewersContent();
                }
                return const _OverviewContent();
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewContent extends GetView<AnalyticsController> {
  const _OverviewContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TappableDateHeader(),
          SizedBox(height: 12.h),
          _EditableMetricsGrid(
            metrics: controller.currentMetrics,
            listTarget: controller.currentListTarget,
          ),
          SizedBox(height: 12.h),
          _DateGraphCard(
            points: controller.graphPointsFromMetrics,
            startDate: controller.graphStartDate,
            endDate: controller.graphEndDate,
            onStartSave: controller.updateStartDate,
            onEndSave: controller.updateEndDate,
          ),
          SizedBox(height: 20.h),

          AppCard(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppConstants.sectionTrafficSource,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.info_outline,
                        size: 14.r,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  ...controller.currentTrafficSources.asMap().entries.map((entry) {
                    final index = entry.key;
                    final source = entry.value;

                    return Column(
                      children: [
                        if (index > 0)
                          Divider(
                            color: Colors.white.withValues(alpha: 0.08),
                            thickness: 0.5,
                            height: 1,
                          ),
                        EditableProgressRow(
                          label: source.label,
                          percentage: source.percentage,
                          onSave: (newLabel, newPct) => controller.updateTrafficSource(
                            controller.is7Days,
                            index,
                            newLabel,
                            newPct,
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),

          // Search Queries
          if (controller.is7Days) ...[
            SizedBox(height: 24.h),
            AppCard(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppConstants.sectionSearchQueries,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.info_outline,
                          size: 14.r,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    ...controller.searchQueries.asMap().entries.map((entry) {
                      final index = entry.key;
                      final query = entry.value;

                      return Column(
                        children: [
                          if (index > 0)
                            Divider(
                              color: Colors.white.withValues(alpha: 0.08),
                              thickness: 0.5,
                              height: 1,
                            ),
                          EditableProgressRow(
                            label: query.label,
                            percentage: query.percentage,
                            onSave: (newLabel, newPct) =>
                                controller.updateSearchQuery(index, newLabel, newPct),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: 40.h),
        ],
      )),
    );
  }
}

class _ViewersContent extends GetView<AnalyticsController> {
  const _ViewersContent();

  Color _donutColor(String label) {
    switch (label) {
      case 'Male':   return const Color(0xFF90CAF9);
      case 'Female': return const Color(0xFF455A64);
      default:       return const Color(0xFF263238);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TappableDateHeader(),



          SizedBox(height: 12.h),
          Row(
            children: List.generate(controller.metricsViewers.length, (i) {
              final m = controller.metricsViewers[i];
              final isFirst = i == 0;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: isFirst ? 8.w : 0),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12.r),
                    border: isFirst
                        ? Border.all(color: AppColors.accent, width: 1.5)
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(m.label, style: AppTextStyles.metricLabel),
                      SizedBox(height: 4.h),
                      _InlineEditText(
                        value: m.value,
                        style: AppTextStyles.metricValue,
                        onSave: (v) => controller.updateMetricValue('viewers', i, v),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 20.h),



          _DateGraphCard(
            points: controller.graphPointsFromMetrics,
            startDate: controller.startDate365d.value,
            endDate: controller.endDate365d.value,
            onStartSave: (v) => controller.startDate365d.value = v,
            onEndSave: (v) => controller.endDate365d.value = v,
          ),
          SizedBox(height: 20.h),
          AppCard(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppConstants.sectionTrafficSource,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Icon(Icons.info_outline, size: 14.r, color: AppColors.textSecondary),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  const _GenderTabRow(),
                  SizedBox(height: 48.h),
                  SizedBox(
                    height: 130.h,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: _DonutPainter(data: controller.genderData),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ...controller.genderData.asMap().entries.map((entry) {
                    final i = entry.key;
                    final g = entry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (i != 0)
                          Divider(
                            color: Colors.white.withValues(alpha: 0.08),
                            thickness: 0.5,
                            height: 0.5,
                          ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Row(
                            children: [
                              Container(
                                width: 8.r,
                                height: 8.r,
                                decoration: BoxDecoration(
                                  color: _donutColor(g.label),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(child: Text(g.label, style: AppTextStyles.bodyPrimary)),
                              _InlineEditNumber(
                                value: g.percentage,
                                onSave: (v) => controller.updateGenderPercentage(i, v),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      )),
    );
  }
}

// Key metrics
class _TappableDateHeader extends GetView<AnalyticsController> {
  const _TappableDateHeader();

  static Future<void> _showDateDialog(
      BuildContext context,
      String current,
      void Function(String) onSave,
      ) async {
    final ctrl = TextEditingController(text: current);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        title: Text(
          'Edit Date',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 15.sp),
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp),
          cursorColor: AppColors.accent,
          decoration: const InputDecoration(
            hintText: 'e.g. Feb 9',
            hintStyle: TextStyle(color: AppColors.textSecondary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.textSecondary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.accent, width: 1.5),
            ),
          ),
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ctrl.text),
            child:const Text('Save', style: TextStyle(color: AppColors.accent)),
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
        Text(AppConstants.sectionKeyMetrics, style: AppTextStyles.heading),
        SizedBox(height: 4.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _showDateDialog(
                context,
                controller.graphStartDate,
                controller.updateStartDate,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                child: Text(controller.graphStartDate, style: AppTextStyles.dateLabel),
              ),
            ),
            Text(' – ', style: AppTextStyles.dateLabel),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _showDateDialog(
                context,
                controller.graphEndDate,
                controller.updateEndDate,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                child: Text(controller.graphEndDate, style: AppTextStyles.dateLabel),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}

// Editable Metrics Grid
class _EditableMetricsGrid extends StatelessWidget {
  final List<MetricCard> metrics;
  final String listTarget;
  const _EditableMetricsGrid({required this.metrics, required this.listTarget});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 8.w,
        childAspectRatio: 1.75,
      ),
      itemCount: metrics.length,
      itemBuilder: (_, i) => _EditableMetricTile(
        metric: metrics[i],
        index: i,
        listTarget: listTarget,
        isHighlighted: i == 0,
      ),
    );
  }
}

// Editable Metric Tile
class _EditableMetricTile extends StatelessWidget {
  final MetricCard metric;
  final int index;
  final String listTarget;
  final bool isHighlighted;

  const _EditableMetricTile({
    required this.metric,
    required this.index,
    required this.listTarget,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AnalyticsController>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
        border: isHighlighted
            ? Border.all(color: AppColors.accent, width: 1.5)
            : null,
      ),
      child: OverflowBox(
        alignment: Alignment.topLeft,
        maxHeight: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(metric.label, style: AppTextStyles.metricLabel),
            SizedBox(height: 2.h),
            _InlineEditText(
              value: metric.value,
              style: AppTextStyles.metricValue,
              onSave: (v) => c.updateMetricValue(listTarget, index, v),
            ),
            SizedBox(height: 2.h),
            if (metric.change != null)
              _EditableChangeRow(
                change: metric.change!,
                isPositive: metric.isPositive,
                onSave: (v) => c.updateMetricChange(listTarget, index, v),
              ),
          ],
        ),
      ),
    );
  }
}

// Inline Edit Text
class _InlineEditText extends StatefulWidget {
  final String value;
  final TextStyle? style;
  final void Function(String) onSave;

  const _InlineEditText({required this.value, required this.onSave, this.style});

  @override
  State<_InlineEditText> createState() => _InlineEditTextState();
}

class _InlineEditTextState extends State<_InlineEditText> {
  bool _editing = false;
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_InlineEditText old) {
    super.didUpdateWidget(old);
    if (!_editing && old.value != widget.value) {
      _ctrl.text = widget.value;
    }
  }

  void _commit() {
    if (!_editing) return;
    final v = _ctrl.text.trim();
    if (v.isNotEmpty) widget.onSave(v);
    setState(() => _editing = false);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      return SizedBox(
        height: 24.h,
        child: TextField(
          controller: _ctrl,
          autofocus: true,
          style: widget.style?.copyWith(fontSize: widget.style?.fontSize ?? 14),
          cursorColor: AppColors.accent,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: const BorderSide(color: AppColors.accent, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide:const BorderSide(color: AppColors.accent, width: 1.5),
            ),
            filled: true,
            fillColor: AppColors.bg,
          ),
          onSubmitted: (_) => _commit(),
          onTapOutside: (_) => _commit(),
          inputFormatters: [LengthLimitingTextInputFormatter(20)],
        ),
      );
    }
    return GestureDetector(
      onTap: () { _ctrl.text = widget.value; setState(() => _editing = true); },
      child: Text(widget.value, style: widget.style, overflow: TextOverflow.ellipsis),
    );
  }
}

// Editable Change Row
class _EditableChangeRow extends StatefulWidget {
  final String change;
  final bool? isPositive;
  final void Function(String) onSave;

  const _EditableChangeRow({required this.change, required this.onSave, this.isPositive});

  @override
  State<_EditableChangeRow> createState() => _EditableChangeRowState();
}

class _EditableChangeRowState extends State<_EditableChangeRow> {
  bool _editing = false;
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.change);
  }

  void _commit() {
    if (!_editing) return;
    final v = _ctrl.text.trim();
    if (v.isNotEmpty) widget.onSave(v);
    setState(() => _editing = false);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final color = widget.isPositive == true ? AppColors.accent : AppColors.textSecondary;

    if (_editing) {
      return SizedBox(
        height: 24.h,
        child: TextField(
          controller: _ctrl,
          autofocus: true,
          style: TextStyle(color: color, fontSize: 10.sp),
          cursorColor: AppColors.accent,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.accent, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.accent, width: 1.2),
            ),
            filled: true,
            fillColor: AppColors.bg,
          ),
          onSubmitted: (_) => _commit(),
          onTapOutside: (_) => _commit(),
          inputFormatters: [LengthLimitingTextInputFormatter(25)],
        ),
      );
    }

    return GestureDetector(
      onTap: () { _ctrl.text = widget.change; setState(() => _editing = true); },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.change != '0' &&
              !widget.change.startsWith('+\$') &&
              !widget.change.startsWith('-\$'))
            Icon(
              widget.isPositive == true
                  ? Icons.cloud_upload_outlined
                  : Icons.cloud_download_outlined,
              color: color,
              size: 11.r,
            ),
          SizedBox(width: 3.w),
          Flexible(
            child: Text(
              widget.change,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color, fontSize: 10.sp),
            ),
          ),
        ],
      ),
    );
  }
}

// Editable Progress Row
class EditableProgressRow extends StatefulWidget {
  final String label;
  final double percentage;
  final void Function(String label, double pct) onSave;

  const EditableProgressRow({
    super.key,
    required this.label,
    required this.percentage,
    required this.onSave,
  });

  @override
  State<EditableProgressRow> createState() => _EditableProgressRowState();
}

class _EditableProgressRowState extends State<EditableProgressRow> {
  bool _editingPct = false;
  late TextEditingController _pctCtrl;
  late String _currentLabel;
  late double _currentPct;

  @override
  void initState() {
    super.initState();
    _currentLabel = widget.label;
    _currentPct   = widget.percentage;
    _pctCtrl = TextEditingController(text: _currentPct.toStringAsFixed(1));
  }

  @override
  void didUpdateWidget(EditableProgressRow old) {
    super.didUpdateWidget(old);
    _currentLabel = widget.label;
    if (!_editingPct) _currentPct = widget.percentage;
  }

  void _commitPct() {
    if (!_editingPct) return;
    final v = double.tryParse(_pctCtrl.text.trim()) ?? _currentPct;
    _currentPct = v.clamp(0, 100);
    setState(() => _editingPct = false);
    widget.onSave(_currentLabel, _currentPct);
  }

  @override
  void dispose() { _pctCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _currentLabel,
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 12.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              _editingPct
                  ? SizedBox(
                width: 55.w,
                height: 22.h,
                child: TextField(
                  controller: _pctCtrl,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(color: AppColors.accent, fontSize: 12.sp),
                  cursorColor: AppColors.accent,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.r),
                      borderSide: const BorderSide(color: AppColors.accent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.r),
                      borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
                    ),
                    filled: true,
                    fillColor: AppColors.bg,
                    suffix: Text('%',
                        style: TextStyle(color: AppColors.accent, fontSize: 11.sp)),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  onSubmitted: (_) => _commitPct(),
                  onTapOutside: (_) => _commitPct(),
                ),
              )
                  : GestureDetector(
                onTap: () {
                  _pctCtrl.text = _currentPct.toStringAsFixed(1);
                  setState(() => _editingPct = true);
                },
                child: Text(
                  '${_currentPct.toStringAsFixed(1)}%',
                  style: TextStyle(color: AppColors.accent, fontSize: 12.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: _currentPct / 100,
              minHeight: 4.h,
              backgroundColor: AppColors.surface,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}

//  Inline Edit Number (gender %)
class _InlineEditNumber extends StatefulWidget {
  final double value;
  final void Function(double) onSave;
  const _InlineEditNumber({required this.value, required this.onSave});

  @override
  State<_InlineEditNumber> createState() => _InlineEditNumberState();
}

class _InlineEditNumberState extends State<_InlineEditNumber> {
  bool _editing = false;
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value.toInt().toString());
  }

  @override
  void didUpdateWidget(_InlineEditNumber old) {
    super.didUpdateWidget(old);
    if (!_editing) _ctrl.text = widget.value.toInt().toString();
  }

  void _commit() {
    if (!_editing) return;
    final v = double.tryParse(_ctrl.text.trim());
    if (v != null) widget.onSave(v);
    setState(() => _editing = false);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      return SizedBox(
        width: 55.w, height: 24.h,
        child: TextField(
          controller: _ctrl,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: AppTextStyles.bodySecondary,
          cursorColor: AppColors.accent,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
            ),
            filled: true,
            fillColor: AppColors.bg,
            suffix: Text('%', style: AppTextStyles.bodySecondary),
          ),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
          onSubmitted: (_) => _commit(),
          onTapOutside: (_) => _commit(),
        ),
      );
    }
    return GestureDetector(
      onTap: () { _ctrl.text = widget.value.toInt().toString(); setState(() => _editing = true); },
      child: Text('${widget.value.toInt()}%', style: AppTextStyles.bodySecondary),
    );
  }
}

// Date Graph Card
class _DateGraphCard extends StatelessWidget {
  final List<double> points;
  final String startDate;
  final String endDate;
  final void Function(String) onStartSave;
  final void Function(String) onEndSave;

  const _DateGraphCard({
    required this.points,
    required this.startDate,
    required this.endDate,
    required this.onStartSave,
    required this.onEndSave,
  });

  Future<void> _showDateDialog(
      BuildContext context,
      String current,
      void Function(String) onSave,
      ) async {
    final ctrl = TextEditingController(text: current);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        title: Text(
          'Edit Date',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 15.sp),
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp),
          cursorColor: AppColors.accent,
          decoration: const InputDecoration(
            hintText: 'e.g. Feb 9',
            hintStyle: TextStyle(color: AppColors.textSecondary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.textSecondary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.accent, width: 1.5),
            ),
          ),
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ctrl.text),
            child: const Text('Save', style: TextStyle(color: AppColors.accent)),
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
    return AppCard(
      child: SizedBox(
        height: 160.h,
        child: CustomPaint(
          painter: LinePainter(points: points),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Transform.translate(
                  offset: Offset(0, 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _showDateDialog(context, startDate, onStartSave),
                        child: Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Text(startDate, style: AppTextStyles.dateLabel),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _showDateDialog(context, endDate, onEndSave),
                        child: Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Text(endDate, style: AppTextStyles.dateLabel),
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

// Gender Tab Row
class _GenderTabRow extends GetView<AnalyticsController> {
  const _GenderTabRow();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      mainAxisSize: MainAxisSize.min,
      children: controller.genderTabs.map((tab) {
        final isSelected = controller.selectedGenderTab.value == tab;
        return GestureDetector(
          onTap: () => controller.selectGenderTab(tab),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(right: 8.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.card1 : AppColors.surface1,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              tab,
              style: TextStyle(
                color: isSelected ? AppColors.textPrimary1 : AppColors.textSecondary,
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    ));
  }
}

// Donut Painter
class _DonutPainter extends CustomPainter {
  final List<dynamic> data;
  _DonutPainter({required this.data});

  static const colors = [
    Color(0xFF90CAF9),
    Color(0xFF455A64),
    Color(0xFF263238),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final total  = data.fold<double>(0, (s, e) => s + e.percentage);
    final cx     = size.width / 2;
    final cy     = size.height * 0.95;
    final radius = size.width * 0.40;
    final stroke = radius * 0.50;

    final paint = Paint()
      ..style       = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap   = StrokeCap.butt;

    double startAngle = math.pi;
    const sweepTotal  = math.pi;

    for (int i = 0; i < data.length; i++) {
      final sweep = (data[i].percentage / total) * sweepTotal;
      paint.color = colors[i % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        startAngle,
        sweep,
        false,
        paint,
      );
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) => true;
}

//  App Bar
class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20.r),
          ),
          Expanded(
            child: Center(child: Text('Analytics', style: AppTextStyles.heading)),
          ),
          SizedBox(width: 20.w),
        ],
      ),
    );
  }
}

//  Tab Bar
class _TabBar extends GetView<AnalyticsController> {
  const _TabBar();

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: controller.tabs.map((tab) {
          final isSelected = controller.selectedTab.value == tab;
          return GestureDetector(
            onTap: () => controller.selectTab(tab),
            child: Container(
              margin: EdgeInsets.only(right: 24.w),
              padding: EdgeInsets.only(bottom: 8.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? AppColors.textPrimary : Colors.transparent,
                    width: 2.h,
                  ),
                ),
              ),
              child: Text(tab,
                  style: isSelected ? AppTextStyles.tabActive : AppTextStyles.tabInactive),
            ),
          );
        }).toList(),
      ),
    ));
  }
}

//  Range Selector
class _RangeSelector extends GetView<AnalyticsController> {
  const _RangeSelector();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...controller.ranges.take(4).map((r) {
              final isSelected = controller.selectedRange.value == r;
              return GestureDetector(
                onTap: () => controller.selectRange(r),
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.textPrimary : AppColors.surface,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(r,
                      style: isSelected ? AppTextStyles.rangeActive : AppTextStyles.rangeInactive),
                ),
              );
            }),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Text('Custom', style: AppTextStyles.rangeInactive),
                  SizedBox(width: 4.w),
                  Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 14.r),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}