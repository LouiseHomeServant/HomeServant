import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/user_role.dart';
import '../../widgets/home_servant_logo.dart';
import '../../widgets/pill_button.dart';
import '../../widgets/pill_text_field.dart';
import '../../widgets/themed_scaffold.dart';

class SignupTenant1Screen extends StatefulWidget {
  const SignupTenant1Screen({super.key, required this.onContinue});

  final ValueChanged<Map<String, String>> onContinue;

  @override
  State<SignupTenant1Screen> createState() => _SignupTenant1ScreenState();
}

class _SignupTenant1ScreenState extends State<SignupTenant1Screen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _referral = TextEditingController();
  static const _role = UserRole.tenant;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _referral.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      role: _role,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Center(child: HomeServantLogo(role: _role, iconSize: 56)),
          const SizedBox(height: 28),
          Text(
            'Welcome Onboard',
            textAlign: TextAlign.center,
            style: AppTextStyles.heading(color: _role.foreground, size: 24),
          ),
          const SizedBox(height: 28),
          _Field(
            label: 'Enter your Name',
            color: _role.foreground,
            controller: _name,
          ),
          const SizedBox(height: 18),
          _Field(
            label: 'Phone Number',
            color: _role.foreground,
            controller: _phone,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 18),
          _Field(
            label: 'Referral code (optional)',
            color: _role.foreground,
            controller: _referral,
          ),
          const SizedBox(height: 28),
          PillButton(
            label: 'Continue',
            backgroundColor: _role.accent,
            textColor: Colors.white,
            onPressed: () {
              widget.onContinue({
                'name': _name.text.trim(),
                'phone': _phone.text.trim(),
                'referral': _referral.text.trim(),
              });
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.color,
    required this.controller,
    this.keyboardType,
  });

  final String label;
  final Color color;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body(color: color, weight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        PillTextField(
          hint: '',
          controller: controller,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
