import 'package:flutter/services.dart';
import '../models/dashboard_theme.dart';

/// Switches the OS home-screen app icon to match the selected [DashboardTheme],
/// via each platform's native alternate-icon API (iOS `setAlternateIconName`,
/// Android launcher `activity-alias` toggling). No-op on platforms that don't
/// support it (web, desktop).
class AppIconService {
  AppIconService._();

  static const _channel = MethodChannel('com.homeservant/app_icon');

  /// Native alternate-icon name per theme, or null for the primary/default
  /// icon (Classic White, which already ships as the app's default icon).
  static String? _iconNameFor(DashboardTheme theme) {
    switch (theme) {
      case DashboardTheme.classic:
        return null;
      case DashboardTheme.midnight:
        return 'Midnight';
      case DashboardTheme.sand:
        return 'Sand';
    }
  }

  static Future<void> apply(DashboardTheme theme) async {
    try {
      await _channel.invokeMethod<bool>('setAppIcon', {'name': _iconNameFor(theme)});
    } on MissingPluginException {
      // Platform side not wired up (e.g. running on web/desktop) — ignore.
    } on PlatformException {
      // Icon switching isn't supported on this device/OS version — ignore.
    }
  }
}
