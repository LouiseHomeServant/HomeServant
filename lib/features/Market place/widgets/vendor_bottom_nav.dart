import 'package:flutter/material.dart';
import '../../../models/dashboard_theme.dart';

/// Floating pill nav for the vendor dashboard — mirrors the shape and
/// motion of [DashboardBottomNav] but with a vendor-specific icon set
/// (Overview / Products / Profile instead of Home / Marketplace / Docs /
/// Profile), so it isn't a fit for the shared widget.
class VendorBottomNav extends StatelessWidget {
  const VendorBottomNav({super.key, required this.currentIndex, required this.onTap, required this.theme});

  final int currentIndex;
  final ValueChanged<int> onTap;
  final DashboardTheme theme;

  static const _icons = [Icons.dashboard_rounded, Icons.inventory_2_outlined, Icons.storefront_rounded];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: theme.navigatorColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_icons.length, (index) {
          final selected = index == currentIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: selected ? theme.background : Colors.transparent, shape: BoxShape.circle),
              child: Icon(_icons[index], color: selected ? theme.accent : theme.navigatorForeground, size: 22),
            ),
          );
        }),
      ),
    );
  }
}

/// Shared page shell for the 3 vendor screens (Overview / Products /
/// Profile) — floats [VendorBottomNav] over [body] the same way on all
/// three, without any of them needing to import one another just to host
/// the nav bar.
class VendorTabScaffold extends StatelessWidget {
  const VendorTabScaffold({
    super.key,
    required this.theme,
    required this.currentIndex,
    required this.onNavTap,
    required this.body,
  });

  final DashboardTheme theme;
  final int currentIndex;
  final ValueChanged<int> onNavTap;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 900), child: body)),
            Positioned(
              left: 20,
              right: 20,
              bottom: 12,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: VendorBottomNav(currentIndex: currentIndex, onTap: onNavTap, theme: theme),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
