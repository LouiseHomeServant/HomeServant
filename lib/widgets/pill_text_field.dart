import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// White, fully-rounded input used throughout every auth / onboarding
/// screen in the prototype.
class PillTextField extends StatelessWidget {
  const PillTextField({
    super.key,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.fillColor = AppColors.white,
    this.textColor = AppColors.navy,
    this.trailing,
    this.onTap,
    this.readOnly = false,
    this.validator,
  });

  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Color fillColor;
  final Color textColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool readOnly;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onTap: onTap,
      readOnly: readOnly,
      validator: validator,
      style: AppTextStyles.body(color: textColor, size: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.body(color: AppColors.hintGrey, size: 16),
        filled: true,
        fillColor: fillColor,
        suffixIcon: trailing,
        contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
        ),
      ),
    );
  }
}

/// A field styled to look tappable (dropdown / picker) with a label above
/// it and a chevron, matching "Upload your Address" / "Means of
/// Identification" on the second onboarding step.
class LabeledDropdownField extends StatelessWidget {
  const LabeledDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.labelColor,
    this.fillColor = AppColors.white,
    this.onTap,
  });

  final String label;
  final String value;
  final Color labelColor;
  final Color fillColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.body(color: labelColor, weight: FontWeight.w600)),
            Icon(Icons.keyboard_arrow_down_rounded, color: labelColor),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(value, style: AppTextStyles.body(color: AppColors.navy, size: 15)),
          ),
        ),
      ],
    );
  }
}
