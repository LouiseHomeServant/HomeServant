import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Four-box OTP entry matching the "Verify Your Email" frames, with
/// auto-advance between boxes and a mutable box fill colour per theme.
class OtpInputRow extends StatefulWidget {
  const OtpInputRow({
    super.key,
    required this.boxColor,
    required this.textColor,
    this.length = 4,
    required this.onChanged,
  });

  final Color boxColor;
  final Color textColor;
  final int length;
  final ValueChanged<String> onChanged;

  @override
  State<OtpInputRow> createState() => _OtpInputRowState();
}

class _OtpInputRowState extends State<OtpInputRow> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _emit() {
    widget.onChanged(_controllers.map((c) => c.text).join());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(widget.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == widget.length - 1 ? 0 : 12),
            child: AspectRatio(
              aspectRatio: 1,
              child: TextField(
                controller: _controllers[index],
                focusNode: _nodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: AppTextStyles.heading(color: widget.textColor, size: 22),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: widget.boxColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.gold, width: 1.5),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && index < widget.length - 1) {
                    _nodes[index + 1].requestFocus();
                  } else if (value.isEmpty && index > 0) {
                    _nodes[index - 1].requestFocus();
                  }
                  _emit();
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
