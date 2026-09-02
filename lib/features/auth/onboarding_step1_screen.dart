import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/user_role.dart';
import '../../widgets/home_servant_logo.dart';
import '../../widgets/pill_button.dart';
import '../../widgets/pill_text_field.dart';
import '../../widgets/themed_scaffold.dart';

class OnboardingStep1Screen extends StatefulWidget {
  const OnboardingStep1Screen({super.key, required this.role, required this.onContinue});

  final UserRole role;
  final ValueChanged<Map<String, String>> onContinue;

  @override
  State<OnboardingStep1Screen> createState() => _OnboardingStep1ScreenState();
}

class _OnboardingStep1ScreenState extends State<OnboardingStep1Screen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _secondaryName = TextEditingController();
  final _referral = TextEditingController();
  final _houseAddress = TextEditingController();
  String? _certificateFileName;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _secondaryName.dispose();
    _referral.dispose();
    _houseAddress.dispose();
    super.dispose();
  }

  Color get _labelColor => widget.role.isLandlord ? widget.role.foreground : widget.role.accent;

  @override
  Widget build(BuildContext context) {
    final role = widget.role;
    return ThemedScaffold(
      role: role,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Center(child: HomeServantLogo(role: role, iconSize: 56, textSize: 24)),
          const SizedBox(height: 28),
          Text('Welcome Onboard !!!!', textAlign: TextAlign.center, style: AppTextStyles.heading(color: role.foreground, size: 24)),
          const SizedBox(height: 28),
          _Field(label: 'Enter your Name', color: _labelColor, controller: _name),
          const SizedBox(height: 18),
          _Field(label: 'Phone Number', color: _labelColor, controller: _phone, keyboardType: TextInputType.phone),
          const SizedBox(height: 18),
          if (role.isLandlord) ...[
            _Field(label: 'House Address', color: _labelColor, controller: _houseAddress),
            const SizedBox(height: 22),
            PillOutlineButton(
              label: _certificateFileName ?? 'Certificate of Ownership',
              textColor: role.foreground,
              icon: Icons.upload_file_rounded,
              onPressed: () => setState(() => _certificateFileName = 'certificate.pdf'),
            ),
          ] else ...[
            _Field(label: 'Enter your Name', color: _labelColor, controller: _secondaryName),
            const SizedBox(height: 18),
            _Field(label: 'Referral code (optional)', color: _labelColor, controller: _referral),
          ],
          const SizedBox(height: 28),
          PillButton(
            label: 'Continue',
            backgroundColor: role.accent,
            textColor: Colors.white,
            onPressed: () {
              widget.onContinue({
                'name': _name.text.trim(),
                'phone': _phone.text.trim(),
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
        Text(label, style: AppTextStyles.body(color: color, weight: FontWeight.w600)),
        const SizedBox(height: 8),
        PillTextField(hint: '', controller: controller, keyboardType: keyboardType),
      ],
    );
  }
}
