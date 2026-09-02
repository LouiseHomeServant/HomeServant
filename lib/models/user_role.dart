import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// The Figma prototype mirrors the same screens for both audiences: a warm
/// navy theme for tenants ("Looking for a Home?") and an inverted gold theme
/// for landlords ("Register as a Landlord").
enum UserRole {
  tenant,
  landlord;

  bool get isLandlord => this == UserRole.landlord;

  /// Background colour of every themed screen for this role.
  Color get background => isLandlord ? AppColors.gold : AppColors.navy;

  /// Colour used for primary buttons, icons drawn on [background].
  Color get accent => isLandlord ? AppColors.navy : AppColors.gold;

  /// Colour used for primary text / headings drawn on [background].
  Color get foreground => isLandlord ? AppColors.navy : AppColors.white;

  /// Colour of the wordmark text ("Home Servant").
  Color get wordmarkColor => isLandlord ? AppColors.navy : AppColors.gold;

  String get label => isLandlord ? 'Landlord' : 'Tenant';
}
