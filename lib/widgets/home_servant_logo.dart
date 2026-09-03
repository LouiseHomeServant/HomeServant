import 'package:flutter/material.dart';
import '../models/user_role.dart';

/// The "Home Servant" house-and-hand mark plus wordmark, reused across every
/// themed screen. Tenant screens use the flattened `logo6.png` lockup (navy
/// icon with gold outline + gold wordmark); landlord screens use the
/// flattened `logo7.png` lockup (dark brown icon + gold wordmark), which
/// stays legible on the landlord dark-brown background.
class HomeServantLogo extends StatelessWidget {
  const HomeServantLogo({super.key, required this.role, this.iconSize = 56});

  final UserRole role;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final asset = role.isLandlord ? 'assets/icons/logo7.png' : 'assets/icons/logo6.png';
    return Image.asset(asset, height: iconSize, fit: BoxFit.contain);
  }
}
