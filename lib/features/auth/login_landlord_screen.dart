import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/user_role.dart';
import '../../widgets/home_servant_logo.dart';
import '../../widgets/pill_button.dart';
import '../../widgets/pill_text_field.dart';
import '../../widgets/terms_footer.dart';
import '../../widgets/themed_scaffold.dart';

class LoginLandlordScreen extends StatefulWidget {
  const LoginLandlordScreen({
    super.key,
    required this.onLogin,
    required this.onSignUp,
  });

  final VoidCallback onLogin;
  final VoidCallback onSignUp;

  @override
  State<LoginLandlordScreen> createState() => _LoginLandlordScreenState();
}

class _LoginLandlordScreenState extends State<LoginLandlordScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  static const _role = UserRole.landlord;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      role: _role,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Center(child: HomeServantLogo(role: _role, iconSize: 60)),
          const SizedBox(height: 64),
          PillTextField(hint: 'Username', controller: _username),
          const SizedBox(height: 16),
          PillTextField(hint: 'Password', controller: _password, obscureText: true),
          const SizedBox(height: 24),
          PillButton(
            label: 'Login',
            backgroundColor: _role.accent,
            textColor: Colors.white,
            onPressed: widget.onLogin,
          ),
          const SizedBox(height: 18),
          Center(
            child: GestureDetector(
              onTap: widget.onSignUp,
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.body(color: _role.foreground),
                  children: [
                    const TextSpan(text: "Don't have an account? "),
                    TextSpan(
                      text: 'Sign Up',
                      style: AppTextStyles.body(color: _role.emphasis, weight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 140),
          TermsFooter(
            mutedColor: _role.foreground.withValues(alpha: 0.55),
            linkColor: _role.foreground,
          ),
        ],
      ),
    );
  }
}
