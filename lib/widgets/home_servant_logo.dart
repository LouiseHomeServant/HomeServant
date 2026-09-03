import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../models/user_role.dart';

enum LogoLayout { stacked, row }

/// The "Home Servant" house-and-hand mark plus wordmark, reused across every
/// themed screen. Tenant screens use the flattened `logo6.png` lockup
/// (navy icon with gold outline + gold wordmark) exported straight from
/// Figma; landlord screens keep the icon tinted solid navy with a
/// dynamically-coloured wordmark to match the flattened icon used there.
class HomeServantLogo extends StatelessWidget {
  const HomeServantLogo({
    super.key,
    required this.role,
    this.layout = LogoLayout.row,
    this.iconSize = 56,
    this.textSize = 26,
  });

  final UserRole role;
  final LogoLayout layout;
  final double iconSize;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    if (!role.isLandlord) {
      return Image.asset('assets/icons/logo6.png', height: iconSize, fit: BoxFit.contain);
    }

    // logo.svg's natural viewBox is 332x263 (not square); sizing by height
    // only lets it scale to its own aspect ratio instead of being
    // letterboxed inside a forced square box.
    final icon = SvgPicture.asset(
      'assets/icons/logo.svg',
      height: iconSize,
      colorFilter: const ColorFilter.mode(AppColors.navy, BlendMode.srcIn),
    );

    final wordmark = Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Home', style: AppTextStyles.display(color: role.wordmarkColor, size: textSize)),
          TextSpan(text: layout == LogoLayout.row ? '\n' : ' ', style: AppTextStyles.display(color: role.wordmarkColor, size: textSize)),
          TextSpan(text: 'Servant', style: AppTextStyles.display(color: role.wordmarkColor, size: textSize)),
        ],
      ),
      textAlign: layout == LogoLayout.stacked ? TextAlign.center : TextAlign.left,
    );

    if (layout == LogoLayout.stacked) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [icon, const SizedBox(height: 12), wordmark],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [icon, const SizedBox(width: 10), wordmark],
    );
  }
}
