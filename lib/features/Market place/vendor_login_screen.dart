import 'package:flutter/material.dart';
import '../../core/responsive.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';
import '../../widgets/pill_button.dart';
import '../../widgets/pill_text_field.dart';
import 'vendor_dashboard_screen.dart';

/// Lets an already-registered vendor sign back in to their shop. Like every
/// other login screen in this prototype there's no real backend — any
/// email/password combination signs the visitor into the one demo shop.
class VendorLoginScreen extends StatefulWidget {
  const VendorLoginScreen({super.key, required this.theme});

  final DashboardTheme theme;

  @override
  State<VendorLoginScreen> createState() => _VendorLoginScreenState();
}

class _VendorLoginScreenState extends State<VendorLoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    if (_email.text.trim().isEmpty || _password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email and password to continue')),
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => VendorDashboardScreen(theme: widget.theme)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ResponsiveCenter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(color: theme.accent.withValues(alpha: 0.15), shape: BoxShape.circle),
                      child: Icon(Icons.storefront_rounded, color: theme.accent, size: 40),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Vendor Login',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading(color: theme.foreground, size: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sign in to manage your shop, products and orders.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body(color: theme.foreground.withValues(alpha: 0.65), size: 15),
                    ),
                    const SizedBox(height: 40),
                    PillTextField(
                      hint: 'Email Address',
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      fillColor: theme.surface,
                      textColor: theme.onSurface,
                    ),
                    const SizedBox(height: 16),
                    PillTextField(
                      hint: 'Password',
                      controller: _password,
                      obscureText: _obscurePassword,
                      fillColor: theme.surface,
                      textColor: theme.onSurface,
                      trailing: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: theme.onSurface.withValues(alpha: 0.6),
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    const SizedBox(height: 28),
                    PillButton(
                      label: 'Login',
                      backgroundColor: theme.accent,
                      textColor: theme.onAccent,
                      onPressed: _login,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            if (Navigator.of(context).canPop())
              Positioned(
                top: 4,
                left: 8,
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.foreground, size: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
