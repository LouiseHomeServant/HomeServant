import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// The Figma prototype mirrors the same screens for both audiences: a warm
/// navy theme for tenants ("Looking for a Home?") and a dark brown theme
/// for landlords ("Register as a Landlord").
enum UserRole {
  tenant,
  landlord;

  bool get isLandlord => this == UserRole.landlord;

  /// Background colour of every themed screen for this role.
  Color get background => isLandlord ? AppColors.landlordBrown : AppColors.navy;

  /// Colour used for primary button fills. Stays dark for both roles since
  /// every button here pairs it with hardcoded white button text.
  Color get accent => isLandlord ? AppColors.navy : AppColors.gold;

  /// Colour used for primary text / headings drawn on [background]. Both
  /// roles have a dark background, so both use the same white foreground.
  Color get foreground => AppColors.white;

  /// Colour for emphasised text/links drawn directly on [background] (e.g.
  /// "Sign Up", "Resend OTP") — distinct from [foreground] so it still reads
  /// as a highlight, and distinct from [accent] because that one has to stay
  /// dark for button-fill contrast even though both roles' backgrounds are
  /// dark too.
  Color get emphasis => AppColors.gold;

  String get label => isLandlord ? 'Landlord' : 'Tenant';
}
