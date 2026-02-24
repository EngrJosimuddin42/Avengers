import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../themes/app_colors.dart';

class InlineEditNumber extends StatefulWidget {
  final double value;
  final void Function(double) onSave;

  const InlineEditNumber({
    super.key,
    required this.value,
    required this.onSave,
  });

  @override
  State<InlineEditNumber> createState() => _InlineEditNumberState();
}

class _InlineEditNumberState extends State<InlineEditNumber> {
  bool _editing = false;
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value.toInt().toString());
  }

  @override
  void didUpdateWidget(InlineEditNumber old) {
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
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      return SizedBox(
        width: 55.w,
        height: 24.h,
        child: TextField(
          controller: _ctrl,
          autofocus: true,
          keyboardType:
          const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          cursorColor: AppColors.textPrimary,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
            EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide:
              const BorderSide(color: AppColors.accent, width: 1.5),
            ),
            filled: true,
            fillColor: AppColors.bg,
            suffix: Text('%', style: AppTextStyles.bodySecondary.copyWith(color: AppColors.textPrimary)),          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
          ],
          onSubmitted: (_) => _commit(),
          onTapOutside: (_) => _commit(),
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        _ctrl.text = widget.value.toInt().toString();
        setState(() => _editing = true);
      },
      child: Text('${widget.value.toInt()}%',
        style: AppTextStyles.bodySecondary.copyWith(color: AppColors.textPrimary)),
      );
  }
}