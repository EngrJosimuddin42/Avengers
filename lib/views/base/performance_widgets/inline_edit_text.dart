import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../themes/app_colors.dart';

class InlineEditText extends StatefulWidget {
  final String value;
  final TextStyle? style;
  final void Function(String) onSave;
  final int maxLength;
  final TextInputType keyboardType;

  const InlineEditText({
    super.key,
    required this.value,
    required this.onSave,
    this.style,
    this.maxLength = 30,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<InlineEditText> createState() => _InlineEditTextState();
}


class _InlineEditTextState extends State<InlineEditText> {
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
  void didUpdateWidget(InlineEditText old) {
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
          style: widget.style ?? TextStyle(color: AppColors.textPrimary, fontSize: 15.sp),
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
