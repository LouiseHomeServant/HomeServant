import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/user_role.dart';
import '../../widgets/otp_input_row.dart';
import '../../widgets/pill_button.dart';
import '../../widgets/terms_footer.dart';
import '../../widgets/themed_scaffold.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key, required this.role, required this.email, required this.onVerified});

  final UserRole role;
  final String email;
  final VoidCallback onVerified;

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  static const _startSeconds = 50;
  int _secondsLeft = _startSeconds;
  Timer? _timer;
  String _code = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = _startSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.role;
    final boxColor = role.isLandlord ? AppColors.offWhite : const Color(0xFF7C859C);
    return ThemedScaffold(
      role: role,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text('Verify Your Email', textAlign: TextAlign.center, style: AppTextStyles.heading(color: role.foreground, size: 30)),
          const SizedBox(height: 6),
          Text(
            'Enter the OTP sent to your Email Account',
            textAlign: TextAlign.center,
            style: AppTextStyles.body(color: role.foreground.withValues(alpha: 0.85)),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Enter OTP', style: AppTextStyles.body(color: role.foreground, weight: FontWeight.w600)),
              Text(
                '0:${_secondsLeft.toString().padLeft(2, '0')}',
                style: AppTextStyles.body(color: role.foreground.withValues(alpha: 0.7), size: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          OtpInputRow(
            boxColor: boxColor,
            textColor: role.isLandlord ? AppColors.navy : AppColors.white,
            onChanged: (value) => setState(() => _code = value),
          ),
          const SizedBox(height: 24),
          PillButton(
            label: 'Continue',
            backgroundColor: role.accent,
            textColor: Colors.white,
            onPressed: _code.length == 4 ? widget.onVerified : null,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: _secondsLeft == 0 ? _startTimer : null,
              child: Text(
                _secondsLeft == 0 ? 'Resend OTP' : 'Resend available after timer ends',
                style: AppTextStyles.body(
                  color: _secondsLeft == 0 ? role.accent : role.foreground.withValues(alpha: 0.4),
                  weight: FontWeight.w600,
                  size: 13,
                ),
              ),
            ),
          ),
          const SizedBox(height: 220),
          TermsFooter(
            mutedColor: role.foreground.withValues(alpha: 0.55),
            linkColor: role.foreground,
          ),
        ],
      ),
    );
  }
}
