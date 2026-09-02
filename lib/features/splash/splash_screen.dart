import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/pill_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, required this.onExplore});

  final VoidCallback onExplore;

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
                  AppColors.navyDark.withValues(alpha: 0.22),
                  AppColors.navy.withValues(alpha: 0.12),
                  AppColors.navyDark.withValues(alpha: 0.3),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  SvgPicture.asset('assets/icons/logo4.svg', width: 170),
                  const SizedBox(height: 20),
                  Text(
                    'Find Your Perfect House\nJust one Click Away',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body(color: AppColors.white, size: 15),
                  ),
                  const Spacer(flex: 4),
                  PillButton(
                    label: 'EXPLORE',
                    backgroundColor: AppColors.navy,
                    textColor: AppColors.white,
                    onPressed: onExplore,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
