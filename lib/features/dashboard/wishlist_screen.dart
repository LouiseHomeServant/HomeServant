import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/responsive.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';
import '../../state/app_state.dart';
import 'models/property.dart';
import 'widgets/property_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key, required this.theme});

  final DashboardTheme theme;

  @override
  Widget build(BuildContext context) {
    final favoriteIds = context.select<AppState, Set<String>>((state) => state.favoritePropertyIds);
    final favorites = mockProperties.where((p) => favoriteIds.contains(p.id)).toList();

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.foreground),
        title: Text('WishList', style: AppTextStyles.heading(color: theme.foreground, size: 18)),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 640,
          child:
              favorites.isEmpty
                  ? _EmptyWishlist(theme: theme)
                  : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    children: [for (final property in favorites) PropertyCard(property: property, theme: theme)],
                  ),
        ),
      ),
    );
  }
}

class _EmptyWishlist extends StatelessWidget {
  const _EmptyWishlist({required this.theme});

  final DashboardTheme theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border_rounded, color: theme.foreground.withValues(alpha: 0.35), size: 56),
            const SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: AppTextStyles.heading(color: theme.foreground, size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart on any property to save it here for later.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body(color: theme.foreground.withValues(alpha: 0.6), size: 14),
            ),
          ],
        ),
      ),
    );
  }
}
