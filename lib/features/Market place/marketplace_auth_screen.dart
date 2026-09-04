import 'package:flutter/material.dart';
import '../../core/responsive.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';
import '../../widgets/pill_button.dart';
import 'marketplace_home_screen.dart';
import 'vendor_login_screen.dart';
import 'vendor_signup_screen.dart';

/// Entry point for the Marketplace tab (the dashboard's cart icon). Asks
/// whether the visitor wants to shop as a customer or sell as a vendor
/// before handing off to the matching flow.
class MarketplaceAuthScreen extends StatelessWidget {
  const MarketplaceAuthScreen({super.key, required this.theme});

  final DashboardTheme theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ResponsiveCenter(
                child: Column(
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
                      'Home Servant Marketplace',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading(color: theme.foreground, size: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Furniture, appliances, fittings and more — everything you need to move in, in one place.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body(color: theme.foreground.withValues(alpha: 0.65), size: 15),
                    ),
                    const SizedBox(height: 48),
                    PillButton(
                      label: 'Proceed as a Customer',
                      backgroundColor: theme.accent,
                      textColor: theme.onAccent,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => MarketplaceHomeScreen(theme: theme)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    PillOutlineButton(
                      label: 'Become a Vendor',
                      backgroundColor: theme.surface,
                      textColor: theme.onSurface,
                      icon: Icons.storefront_outlined,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => VendorSignupScreen(theme: theme)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => VendorLoginScreen(theme: theme)),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.body(color: theme.foreground.withValues(alpha: 0.65), size: 14),
                          children: [
                            const TextSpan(text: 'Already a vendor? '),
                            TextSpan(
                              text: 'Login as a Vendor',
                              style: AppTextStyles.body(color: theme.accent, weight: FontWeight.w700, size: 14),
                            ),
                          ],
                        ),
                      ),
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
