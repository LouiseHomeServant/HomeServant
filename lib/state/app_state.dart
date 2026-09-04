import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/dashboard_theme.dart';
import '../models/user_role.dart';
import '../services/app_icon_service.dart';

/// Holds the small amount of state that needs to travel across the
/// multi-step onboarding flow (role, email being verified, collected
/// profile fields) before a real backend exists.
class AppState extends ChangeNotifier {
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
}
