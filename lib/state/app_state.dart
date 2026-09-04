import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dashboard_theme.dart';
import '../models/user_role.dart';
import '../services/app_icon_service.dart';

/// Holds the small amount of state that needs to travel across the
/// multi-step onboarding flow (role, email being verified, collected
/// profile fields) before a real backend exists.
///
/// Persisted locally on-device (via [SharedPreferences]) so it survives a
/// full app restart, not just backgrounding — there's still no backend, this
/// is purely local storage. Every [notifyListeners] call writes the current
/// state back out, so no individual setter needs to remember to save.
class AppState extends ChangeNotifier {
  static const _prefsKey = 'app_state_v1';

  /// True once [load] has finished restoring (or found nothing to restore).
  /// AppLockGate waits for this before deciding whether a cold start should
  /// open locked, so it reads the setting as it was *before* this launch —
  /// not a value flipped live during the current session (see [load]).
  bool isLoaded = false;

  UserRole role = UserRole.tenant;
  String email = '';
  String fullName = '';
  String phoneNumber = '';
  String houseAddress = '';
  String referralCode = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  DateTime? dateOfBirth;
  String? profilePhotoPath;
  DashboardTheme dashboardTheme = DashboardTheme.classic;

  // --- Wishlist ---------------------------------------------------------
  final Set<String> favoritePropertyIds = {};

  bool isFavorite(String propertyId) => favoritePropertyIds.contains(propertyId);

  void toggleFavorite(String propertyId) {
    if (!favoritePropertyIds.remove(propertyId)) {
      favoritePropertyIds.add(propertyId);
    }
    notifyListeners();
  }

  // --- Notification preferences -----------------------------------------
  bool pushNotificationsEnabled = true;
  bool newMessageNotifications = true;
  bool propertyUpdateNotifications = true;
  // Ties directly into the Wishlist feature — lets a tenant know the moment
  // a house they've saved gets cheaper, without having to keep re-checking it.
  bool wishlistPriceDropAlerts = true;
  bool promotionalNotifications = false;

  void setPushNotificationsEnabled(bool value) {
    pushNotificationsEnabled = value;
    notifyListeners();
  }

  void setNewMessageNotifications(bool value) {
    newMessageNotifications = value;
    notifyListeners();
  }

  void setPropertyUpdateNotifications(bool value) {
    propertyUpdateNotifications = value;
    notifyListeners();
  }

  void setWishlistPriceDropAlerts(bool value) {
    wishlistPriceDropAlerts = value;
    notifyListeners();
  }

  void setPromotionalNotifications(bool value) {
    promotionalNotifications = value;
    notifyListeners();
  }

  // --- Security: two-factor authentication -------------------------------
  bool twoFactorEnabled = false;

  void setTwoFactorEnabled(bool value) {
    twoFactorEnabled = value;
    notifyListeners();
  }

  // --- Security: app lock --------------------------------------------------
  bool appLockEnabled = false;
  String? appLockPin;

  void enableAppLock(String pin) {
    appLockEnabled = true;
    appLockPin = pin;
    notifyListeners();
  }

  void disableAppLock() {
    appLockEnabled = false;
    appLockPin = null;
    notifyListeners();
  }

  void selectRole(UserRole newRole) {
    role = newRole;
    notifyListeners();
  }

  void setDashboardTheme(DashboardTheme theme) {
    dashboardTheme = theme;
    notifyListeners();
    AppIconService.apply(theme);
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setProfileBasics({
    required String name,
    required String phone,
    String? houseAddress,
    String? referralCode,
  }) {
    fullName = name;
    phoneNumber = phone;
    if (houseAddress != null) this.houseAddress = houseAddress;
    if (referralCode != null) this.referralCode = referralCode;
    notifyListeners();
  }

  void setProfilePhoto(String? path) {
    profilePhotoPath = path;
    notifyListeners();
  }

  void updateProfileDetails({
    required String houseAddress,
    required String phoneNumber,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required DateTime? dateOfBirth,
  }) {
    this.houseAddress = houseAddress;
    this.phoneNumber = phoneNumber;
    this.email = email;
    this.password = password;
    this.firstName = firstName;
    this.lastName = lastName;
    this.dateOfBirth = dateOfBirth;
    notifyListeners();
  }

  /// Generates a shareable referral code the first time it's needed (e.g.
  /// opening "Invite Friends") if signup never set one.
  String ensureReferralCode() {
    if (referralCode.isNotEmpty) return referralCode;
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rand = Random();
    referralCode = 'HS-${List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join()}';
    notifyListeners();
    return referralCode;
  }

  /// Deactivating just ends the local session today (there's no backend to
  /// flag the account as inactive) — kept as its own method, distinct from
  /// [deleteAccount], so a future backend integration has a clear place to
  /// send a "deactivate" request instead of a destructive delete.
  void deactivateAccount() => _clearSession();

  void deleteAccount() => _clearSession();

  void _clearSession() {
    role = UserRole.tenant;
    email = '';
    fullName = '';
    phoneNumber = '';
    houseAddress = '';
    referralCode = '';
    password = '';
    firstName = '';
    lastName = '';
    dateOfBirth = null;
    profilePhotoPath = null;
    favoritePropertyIds.clear();
    pushNotificationsEnabled = true;
    newMessageNotifications = true;
    propertyUpdateNotifications = true;
    wishlistPriceDropAlerts = true;
    promotionalNotifications = false;
    twoFactorEnabled = false;
    appLockEnabled = false;
    appLockPin = null;
    dashboardTheme = DashboardTheme.classic;
    notifyListeners();
    AppIconService.apply(dashboardTheme);
  }

  // --- Local persistence --------------------------------------------------
  //
  // Every notifyListeners() call also writes the current state to disk, so
  // it survives a full app restart (not just backgrounding). This is plain
  // on-device storage — there's still no backend/server involved.

  @override
  void notifyListeners() {
    super.notifyListeners();
    unawaited(_save());
  }

  Map<String, dynamic> _toJson() => {
    'role': role.name,
    'email': email,
    'fullName': fullName,
    'phoneNumber': phoneNumber,
    'houseAddress': houseAddress,
    'referralCode': referralCode,
    'password': password,
    'firstName': firstName,
    'lastName': lastName,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'profilePhotoPath': profilePhotoPath,
    'dashboardTheme': dashboardTheme.name,
    'favoritePropertyIds': favoritePropertyIds.toList(),
    'pushNotificationsEnabled': pushNotificationsEnabled,
    'newMessageNotifications': newMessageNotifications,
    'propertyUpdateNotifications': propertyUpdateNotifications,
    'wishlistPriceDropAlerts': wishlistPriceDropAlerts,
    'promotionalNotifications': promotionalNotifications,
    'twoFactorEnabled': twoFactorEnabled,
    'appLockEnabled': appLockEnabled,
    'appLockPin': appLockPin,
  };

  void _fromJson(Map<String, dynamic> json) {
    role = UserRole.values.firstWhere((r) => r.name == json['role'], orElse: () => UserRole.tenant);
    email = json['email'] as String? ?? '';
    fullName = json['fullName'] as String? ?? '';
    phoneNumber = json['phoneNumber'] as String? ?? '';
    houseAddress = json['houseAddress'] as String? ?? '';
    referralCode = json['referralCode'] as String? ?? '';
    password = json['password'] as String? ?? '';
    firstName = json['firstName'] as String? ?? '';
    lastName = json['lastName'] as String? ?? '';
    final dob = json['dateOfBirth'] as String?;
    dateOfBirth = dob != null ? DateTime.tryParse(dob) : null;
    profilePhotoPath = json['profilePhotoPath'] as String?;
    dashboardTheme = DashboardTheme.values.firstWhere(
      (t) => t.name == json['dashboardTheme'],
      orElse: () => DashboardTheme.classic,
    );
    favoritePropertyIds
      ..clear()
      ..addAll((json['favoritePropertyIds'] as List?)?.cast<String>() ?? const []);
    pushNotificationsEnabled = json['pushNotificationsEnabled'] as bool? ?? true;
    newMessageNotifications = json['newMessageNotifications'] as bool? ?? true;
    propertyUpdateNotifications = json['propertyUpdateNotifications'] as bool? ?? true;
    wishlistPriceDropAlerts = json['wishlistPriceDropAlerts'] as bool? ?? true;
    promotionalNotifications = json['promotionalNotifications'] as bool? ?? false;
    twoFactorEnabled = json['twoFactorEnabled'] as bool? ?? false;
    appLockEnabled = json['appLockEnabled'] as bool? ?? false;
    appLockPin = json['appLockPin'] as String?;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(_toJson()));
  }

  /// Restores state saved by a previous session, if any. Call once, right
  /// after construction — keeps defaults (but still marks [isLoaded]) on a
  /// fresh install.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      try {
        _fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {
        // Corrupt/incompatible saved state — ignore it and keep defaults.
      }
    }
    isLoaded = true;
    super.notifyListeners(); // restored data, not a change to persist again
  }
}
