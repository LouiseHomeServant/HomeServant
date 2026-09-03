import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/user_role.dart';
import '../../widgets/home_servant_logo.dart';
import '../../widgets/pill_button.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key, required this.onLogin, required this.onSignUp});

  final VoidCallback onLogin;
  final VoidCallback onSignUp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/homepage.jpg', fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.navyDark.withValues(alpha: 0.3),
                  AppColors.navy.withValues(alpha: 0.2),
                  AppColors.navyDark.withValues(alpha: 0.35),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                if (Navigator.of(context).canPop())
                  Positioned(
                    top: 4,
                    left: 8,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      const Spacer(flex: 2),
                      const HomeServantLogo(
                        role: UserRole.tenant,
                        iconSize: 64,
                        textSize: 26,
                      ),
                      const Spacer(flex: 2),
                      Text(
                        'Get Started with\nHome Servant',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading(
                          color: AppColors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Find your dream home or manage your properties with ease.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body(
                          color: AppColors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(height: 28),
                      PillButton(
                        label: 'Login',
                        backgroundColor: AppColors.navy,
                        textColor: AppColors.white,
                        onPressed: onLogin,
                      ),
                      const SizedBox(height: 14),
                      PillButton(
                        label: 'Sign Up',
                        backgroundColor: AppColors.gold,
                        textColor: AppColors.navy,
                        onPressed: onSignUp,
                      ),
                      const Spacer(flex: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
