import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.navy,
        primary: AppColors.navy,
        secondary: AppColors.gold,
      ),
      textTheme: TextTheme(
        bodyMedium: AppTextStyles.body(color: AppColors.navy),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.navy),
        titleTextStyle: AppTextStyles.heading(color: AppColors.navy, size: 18),
      ),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
