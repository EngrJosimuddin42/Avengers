import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../themes/app_colors.dart';

class EditableChangeRow extends StatefulWidget {
  final String change;
  final bool? isPositive;
  final void Function(String) onSave;

  const EditableChangeRow({
    super.key,
    required this.change,
    required this.onSave,
    this.isPositive,
  });

  @override
  State<EditableChangeRow> createState() => _EditableChangeRowState();
}

class _EditableChangeRowState extends State<EditableChangeRow> {
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
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryChangeColor = widget.isPositive == true
        ? AppColors.accent
        : AppColors.textSecondary;

    if (_editing) {
      return SizedBox(
        height: 24.h,
        child: TextField(
          controller: _ctrl,
          autofocus: true,
          style: TextStyle(color: primaryChangeColor, fontSize: 10.sp),
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
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        _ctrl.text = widget.change;
        setState(() => _editing = true);
      },
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
              color: primaryChangeColor,
              size: 11.r,
            ),
          SizedBox(width: 3.w),

          Flexible(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: _buildTextSpans(primaryChangeColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildTextSpans(Color primaryColor) {
    final bool isSpecialMetric = widget.change == '0' ||
        widget.change.contains('\$');

    final Color effectiveColor = isSpecialMetric
        ? AppColors.textSecondary
        : primaryColor;

    if (!widget.change.contains(' (')) {
      return [
        TextSpan(
          text: widget.change,
          style: TextStyle(
              color: effectiveColor,
              fontSize: 10.sp
          ),
        )
      ];
    }

    final parts = widget.change.split(' (');
    return [
      TextSpan(
        text: parts[0],
        style: TextStyle(
            color: effectiveColor,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500
        ),
      ),
      TextSpan(
        text: ' (${parts[1]}',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 10.sp,
        ),
      ),
    ];
  }
}