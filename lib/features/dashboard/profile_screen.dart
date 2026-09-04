import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';
import '../../state/app_state.dart';
import '../../widgets/invite_friends_sheet.dart';
import '../../widgets/theme_picker_sheet.dart';
import '../../widgets/upload_picker.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import 'wishlist_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.onLogOut});

  final VoidCallback onLogOut;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = appState.dashboardTheme;
    final photoPath = appState.profilePhotoPath;
    final badgeColor = Color.alphaBlend(theme.foreground.withValues(alpha: 0.14), theme.background);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
      children: [
        Row(
          children: [
            Icon(Icons.badge_outlined, color: theme.accent, size: 22),
            const SizedBox(width: 10),
            Text('Profile Settings', style: AppTextStyles.heading(color: theme.accent, size: 20)),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: theme.foreground, width: 1.4),
            image: photoPath != null
                ? DecorationImage(image: imageProviderForPath(photoPath), fit: BoxFit.cover)
                : null,
          ),
          child: photoPath == null ? Icon(Icons.person_outline, color: theme.foreground, size: 40) : null,
        ),
        const SizedBox(height: 16),
        _EditProfileButton(
          theme: theme,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EditProfileScreen())),
        ),
        const SizedBox(height: 20),
        Divider(color: theme.foreground.withValues(alpha: 0.15), height: 1),
        _ProfileMenuTile(
          icon: Icons.favorite_border_rounded,
          label: 'WishList',
          theme: theme,
          badgeColor: badgeColor,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => WishlistScreen(theme: theme))),
        ),
        _ProfileMenuTile(
          icon: Icons.settings_outlined,
          label: 'Settings',
          theme: theme,
          badgeColor: badgeColor,
          onTap:
              () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => SettingsScreen(theme: theme, onAccountClosed: onLogOut)),
              ),
        ),
        _ProfileMenuTile(
          icon: Icons.remove_red_eye_outlined,
          label: 'Theme',
          theme: theme,
          badgeColor: badgeColor,
          onTap: () async {
            final picked = await showThemePickerSheet(context, current: theme);
            if (picked != null && context.mounted) {
              context.read<AppState>().setDashboardTheme(picked);
            }
          },
        ),
        _ProfileMenuTile(
          icon: Icons.person_add_alt_outlined,
          label: 'Invite Friends',
          theme: theme,
          badgeColor: badgeColor,
          onTap: () => showInviteFriendsSheet(context, theme: theme),
        ),
        _ProfileMenuTile(
          icon: Icons.logout_rounded,
          label: 'Log Out',
          theme: theme,
          badgeColor: badgeColor,
          onTap: onLogOut,
          showDivider: false,
        ),
      ],
    );
  }
}

class _EditProfileButton extends StatelessWidget {
  const _EditProfileButton({required this.theme, required this.onTap});

  final DashboardTheme theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.accent, width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_outlined, color: theme.accent, size: 16),
            const SizedBox(width: 8),
            Text('Edit Profile', style: AppTextStyles.body(color: theme.accent, weight: FontWeight.w700, size: 14)),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({
    required this.icon,
    required this.label,
    required this.theme,
    required this.badgeColor,
    required this.onTap,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final DashboardTheme theme;
  final Color badgeColor;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
                  child: Icon(icon, color: theme.accent, size: 19),
                ),
                const SizedBox(width: 16),
                Text(label, style: AppTextStyles.body(color: theme.foreground, size: 15.5, weight: FontWeight.w600)),
              ],
            ),
          ),
        ),
        if (showDivider) Divider(color: theme.foreground.withValues(alpha: 0.15), height: 1),
      ],
    );
  }
}
