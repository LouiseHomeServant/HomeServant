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
}
