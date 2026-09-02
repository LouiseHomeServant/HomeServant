import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/user_role.dart';
import '../../widgets/home_servant_logo.dart';
import '../../widgets/pill_button.dart';
import '../../widgets/pill_text_field.dart';
import '../../widgets/terms_footer.dart';
import '../../widgets/themed_scaffold.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.role, required this.onContinue});

  final UserRole role;
  final ValueChanged<String> onContinue;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.role;
    return ThemedScaffold(
      role: role,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Center(child: HomeServantLogo(role: role, iconSize: 60, textSize: 26)),
            const SizedBox(height: 56),
            Text('Sign Up', textAlign: TextAlign.center, style: AppTextStyles.heading(color: role.foreground, size: 30)),
            const SizedBox(height: 6),
            Text(
              'Enter your email to signUp',
              textAlign: TextAlign.center,
              style: AppTextStyles.body(color: role.foreground.withValues(alpha: 0.85)),
            ),
            const SizedBox(height: 28),
            PillTextField(
              hint: 'email@domain.com',
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || !value.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 18),
            PillButton(
              label: 'Continue',
              backgroundColor: role.accent,
              textColor: Colors.white,
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  widget.onContinue(_email.text.trim());
                }
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Divider(color: role.foreground.withValues(alpha: 0.4))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Sign in with social media',
                    style: AppTextStyles.body(color: role.foreground.withValues(alpha: 0.7), size: 13),
                  ),
                ),
                Expanded(child: Divider(color: role.foreground.withValues(alpha: 0.4))),
              ],
            ),
            const SizedBox(height: 24),
            GoogleSignInButton(onPressed: () => widget.onContinue(_email.text.trim())),
            const SizedBox(height: 140),
            TermsFooter(
              mutedColor: role.foreground.withValues(alpha: 0.55),
              linkColor: role.foreground,
            ),
          ],
        ),
      ),
    );
  }
}
