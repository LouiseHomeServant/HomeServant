import 'package:flutter/material.dart';
import '../core/theme/app_text_styles.dart';

/// "By clicking continue, you agree to our Terms of Service and Privacy
/// Policy" footer shown on every auth screen.
class TermsFooter extends StatelessWidget {
  const TermsFooter({super.key, required this.mutedColor, required this.linkColor});

  final Color mutedColor;
  final Color linkColor;

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.body(color: mutedColor, size: 12.5);
    final link = AppTextStyles.body(color: linkColor, size: 12.5, weight: FontWeight.w700);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: muted,
        children: [
          const TextSpan(text: 'By clicking continue, you agree to our '),
          TextSpan(text: 'Terms of Service', style: link),
          const TextSpan(text: ' and '),
          TextSpan(text: 'Privacy Policy', style: link),
        ],
      ),
    );
  }
}
