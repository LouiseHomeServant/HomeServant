import 'package:flutter/material.dart';
import '../../core/responsive.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';
import '../../widgets/pill_button.dart';

/// Shown once a vendor application is submitted. There's no vendor
/// dashboard yet, so this simply confirms the submission (mirroring the
/// rest of the app, which mocks its backend) and hands the visitor back to
/// wherever they came from.
class VendorSignupSuccessScreen extends StatelessWidget {
  const VendorSignupSuccessScreen({super.key, required this.theme, required this.businessName});

  final DashboardTheme theme;
  final String businessName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Center(
          child: ResponsiveCenter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(color: theme.accent.withValues(alpha: 0.15), shape: BoxShape.circle),
                    child: Icon(Icons.check_circle_rounded, color: theme.accent, size: 48),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Application Submitted!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading(color: theme.foreground, size: 22),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Thanks for signing up, $businessName. We'll review your vendor application and notify you once it's approved — this usually takes 24–48 hours.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body(color: theme.foreground.withValues(alpha: 0.65), size: 14.5),
                  ),
                  const SizedBox(height: 36),
                  PillButton(
                    label: 'Back to Marketplace',
                    backgroundColor: theme.accent,
                    textColor: theme.onAccent,
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
