import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../themes/app_colors.dart';

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
    _currentPct = widget.percentage;
    _pctCtrl =
        TextEditingController(text: _currentPct.toStringAsFixed(1));
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
  void dispose() {
    _pctCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _currentLabel,
                  style: TextStyle(
                      color: AppColors.textPrimary, fontSize: 15.sp),
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
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  style: TextStyle(
                      color: AppColors.textPrimary, fontSize: 13.sp),
                  cursorColor: AppColors.textPrimary,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 4.w, vertical: 3.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.r),
                      borderSide: const BorderSide(
                          color: AppColors.accent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.r),
                      borderSide: const BorderSide(
                          color: AppColors.accent, width: 1.5),
                    ),
                    filled: true,
                    fillColor: AppColors.bg,
                    suffix: Text('%',
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 11.sp)),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d*')),
                  ],
                  onSubmitted: (_) => _commitPct(),
                  onTapOutside: (_) => _commitPct(),
                ),
              )
                  : GestureDetector(
                onTap: () {
                  _pctCtrl.text =
                      _currentPct.toStringAsFixed(1);
                  setState(() => _editingPct = true);
                },
                child: Text(
                  '${_currentPct.toStringAsFixed(1)}%',
                  style: TextStyle(
                      color: AppColors.textPrimary, fontSize: 13.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: _currentPct / 100,
              minHeight: 8.h,
              backgroundColor: AppColors.surface,
              valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}