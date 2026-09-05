import 'package:flutter/material.dart';
import '../../models/dashboard_theme.dart';
import 'marketplace_auth_screen.dart';

/// Hosts the entire Marketplace flow (customer shopping and the vendor
/// side) in its own nested [Navigator], reached as a single push from a
/// dashboard's bottom nav.
///
/// Every Marketplace screen navigates with plain `Navigator.of(context)`
/// pushes rather than go_router routes, so on Flutter Web those pushes
/// never touch the browser's URL/history. Without this wrapper, pressing
/// the browser back button while several screens deep in the Marketplace
/// went straight to go_router's back-button handling, which jumped to
/// whatever URL preceded `/dashboard` (typically the login screen) instead
/// of stepping back one Marketplace screen at a time. [NavigatorPopHandler]
/// lets this nested Navigator claim the back button first: it pops its own
/// stack while there's more than one route on it, and only lets the press
/// fall through to go_router (popping back to the dashboard) once this
/// Navigator is back down to its single root route.
class MarketplaceNavigatorHost extends StatefulWidget {
  const MarketplaceNavigatorHost({super.key, required this.theme});

  final DashboardTheme theme;

  @override
  State<MarketplaceNavigatorHost> createState() => _MarketplaceNavigatorHostState();
}

class _MarketplaceNavigatorHostState extends State<MarketplaceNavigatorHost> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler(
      onPopWithResult: (result) => _navigatorKey.currentState?.maybePop(),
      child: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          settings: settings,
          builder: (_) => MarketplaceAuthScreen(theme: widget.theme),
        ),
      ),
    );
  }
}
