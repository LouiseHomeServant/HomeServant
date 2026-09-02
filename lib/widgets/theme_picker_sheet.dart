import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../models/dashboard_theme.dart';

/// Bottom sheet that lets the user pick one of the three brand-colour
/// combinations (navy, sand #F2CF8F, white) used across the dashboard and
/// profile screens.
Future<DashboardTheme?> showThemePickerSheet(
  BuildContext context, {
  required DashboardTheme current,
}) {
  return showModalBottomSheet<DashboardTheme>(
    context: context,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (context) => _ThemePickerSheet(current: current),
  );
}

class _ThemePickerSheet extends StatelessWidget {
  const _ThemePickerSheet({required this.current});

  final DashboardTheme current;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose a Theme', style: AppTextStyles.heading(color: AppColors.navy, size: 20)),
            const SizedBox(height: 20),
            ...DashboardTheme.values.map(
              (theme) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ThemeOptionTile(
                  theme: theme,
                  selected: theme == current,
                  onTap: () => Navigator.of(context).pop(theme),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({required this.theme, required this.selected, required this.onTap});

  final DashboardTheme theme;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.navy : AppColors.navy.withValues(alpha: 0.12),
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            _Swatch(colors: theme.swatches),
            const SizedBox(width: 14),
            Expanded(
              child: Text(theme.label, style: AppTextStyles.body(color: AppColors.navy, size: 15, weight: FontWeight.w700)),
            ),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected ? AppColors.navy : AppColors.navy.withValues(alpha: 0.25),
            ),
          ],
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: _dot(colors[0], 28),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: _dot(colors[1], 20),
          ),
          Positioned(
            right: 4,
            bottom: 0,
            child: _dot(colors[2], 16),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
      ),
    );
  }
}
