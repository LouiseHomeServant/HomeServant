import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Personalisation applied to the signed-in tenant experience (dashboard +
/// profile), picked from the "Theme" row on the profile screen. The brand
/// only has three colours — navy, sand (#F2CF8F), and white — so each theme
/// is just those three recombined into different roles.
enum DashboardTheme {
  midnight,
  sand,
  classic;

  /// Screen background.
  Color get background {
    switch (this) {
      case DashboardTheme.midnight:
        return AppColors.navy;
      case DashboardTheme.sand:
        return AppColors.sand;
      case DashboardTheme.classic:
        return AppColors.white;
    }
  }

  /// Cards, inputs, and other raised surfaces.
  Color get surface {
    switch (this) {
      case DashboardTheme.midnight:
        return AppColors.white;
      case DashboardTheme.sand:
        return AppColors.white;
      case DashboardTheme.classic:
        return AppColors.sand;
    }
  }

  /// Buttons, selected states, highlighted icons.
  Color get accent {
    switch (this) {
      case DashboardTheme.midnight:
        return AppColors.sand;
      case DashboardTheme.sand:
        return AppColors.navy;
      case DashboardTheme.classic:
        return AppColors.navy;
    }
  }

  /// Primary text/icon colour drawn directly on [background].
  Color get foreground {
    switch (this) {
      case DashboardTheme.midnight:
        return AppColors.white;
      case DashboardTheme.sand:
        return AppColors.navy;
      case DashboardTheme.classic:
        return AppColors.navy;
    }
  }

  /// Text/icon colour drawn on top of [surface]. Every theme's [surface] is
  /// a light colour (white or sand), so — unlike [foreground], which flips
  /// to white on Midnight to contrast with its navy background — this stays
  /// navy across all three themes.
  Color get onSurface => AppColors.navy;

  /// Dashboard location-pin colour. [accent] alone would make Sand and
  /// Classic both render plain navy (their shared accent) — indistinguishable
  /// from one another. Both themes' backgrounds are light, so navy is the
  /// only high-contrast option in the brand palette for either; rather than
  /// reach for an off-brand hue (or a washed-out white-on-sand pairing) this
  /// gives Sand a richer near-black navy so the two still read as distinct
  /// without sacrificing legibility.
  Color get locationPinColor {
    switch (this) {
      case DashboardTheme.midnight:
        return AppColors.sand;
      case DashboardTheme.sand:
        return AppColors.navyDark;
      case DashboardTheme.classic:
        return AppColors.navy;
    }
  }

  /// Colour for text/icons drawn on top of [accent].
  Color get onAccent {
    switch (this) {
      case DashboardTheme.midnight:
        return AppColors.navy;
      case DashboardTheme.sand:
        return AppColors.white;
      case DashboardTheme.classic:
        return AppColors.white;
    }
  }

  /// Background of the floating bottom navigator. Deliberately distinct from
  /// [background] so the bar reads as its own surface against every themed
  /// page: blue on Classic White, sand on Midnight, white on Sand.
  Color get navigatorColor {
    switch (this) {
      case DashboardTheme.midnight:
        return AppColors.sand;
      case DashboardTheme.sand:
        return AppColors.white;
      case DashboardTheme.classic:
        return AppColors.navy;
    }
  }

  /// Unselected icon colour on the navigator, contrasting with
  /// [navigatorColor].
  Color get navigatorForeground {
    switch (this) {
      case DashboardTheme.midnight:
        return AppColors.navy;
      case DashboardTheme.sand:
        return AppColors.navy;
      case DashboardTheme.classic:
        return AppColors.white;
    }
  }

  String get label {
    switch (this) {
      case DashboardTheme.midnight:
        return 'Midnight';
      case DashboardTheme.sand:
        return 'Sand';
      case DashboardTheme.classic:
        return 'Classic White';
    }
  }

  /// Swatch colours for the picker preview, background first.
  List<Color> get swatches => [background, accent, surface];
}
