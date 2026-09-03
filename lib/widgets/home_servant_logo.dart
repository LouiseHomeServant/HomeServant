import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/user_role.dart';

/// The "Home Servant" house-and-hand mark plus wordmark, reused across every
/// themed screen. Tenant screens use the flattened `tenant.png` lockup;
/// landlord screens use the flattened `landlord.png` lockup.
///
/// Those flattened PNGs bake in fixed colours, so they only stay legible
/// against the one background each was drawn for. Anywhere the background
/// is chosen at runtime (e.g. the dashboard's switchable [DashboardTheme]),
/// pass [color] instead: it swaps in the icon-only `logo.svg` recoloured to
/// a single flat tint via [ColorFilter], which always contrasts because the
/// caller derives it from that same background.
class HomeServantLogo extends StatelessWidget {
  const HomeServantLogo({super.key, required this.role, this.iconSize = 56, this.color});

  final UserRole role;
  final double iconSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (color != null) {
      return SvgPicture.asset(
        'assets/icons/logo.svg',
        height: iconSize,
        colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
      );
    }
    final asset = role.isLandlord ? 'assets/icons/landlord.png' : 'assets/icons/tenant.png';
    return Image.asset(asset, height: iconSize, fit: BoxFit.contain);
  }
}
