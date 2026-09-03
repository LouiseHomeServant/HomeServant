import 'package:flutter/material.dart';

/// Width thresholds used to adapt layouts for tablet/desktop browsers.
/// The app is designed phone-first; these exist purely so the web build
/// doesn't stretch that design edge-to-edge on a wide viewport.
class Breakpoints {
  Breakpoints._();

  static const double medium = 700;
  static const double expanded = 1000;
}

/// Centers [child] within [maxWidth] once the viewport grows past phone
/// size. Below that width it behaves like plain full-width content, so
/// mobile layout is unaffected; only wide browser windows are constrained.
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({super.key, required this.child, this.maxWidth = 480});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// How many columns a card grid (e.g. the property feed) should use for a
/// given available width: 1 on phones, 2 on tablets, 3 on desktop browsers.
int gridColumnsForWidth(double width) {
  if (width >= Breakpoints.expanded) return 3;
  if (width >= Breakpoints.medium) return 2;
  return 1;
}
