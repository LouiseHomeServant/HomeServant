import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/dashboard_theme.dart';
import '../models/property.dart';

class PropertyCard extends StatefulWidget {
  const PropertyCard({super.key, required this.property, required this.theme});

  final Property property;
  final DashboardTheme theme;

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  bool _favorited = false;

  @override
  Widget build(BuildContext context) {
    final property = widget.property;
    final theme = widget.theme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 11,
                  child: Image.asset(property.imageAsset, fit: BoxFit.cover, width: double.infinity),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => setState(() => _favorited = !_favorited),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.black.withValues(alpha: 0.35),
                      child: Icon(
                        _favorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (i) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: i == 0 ? 1 : 0.5),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(property.title, style: AppTextStyles.body(color: theme.foreground, size: 15, weight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(property.location, style: AppTextStyles.body(color: theme.accent, size: 13, weight: FontWeight.w600)),
                  ],
                ),
              ),
              Row(
                children: [
                  ..._stars(property.rating, theme),
                  const SizedBox(width: 4),
                  Text(property.rating.toString(), style: AppTextStyles.body(color: theme.foreground, size: 13)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Stars sit directly on `theme.background`, and the brand's gold reads
  // poorly there on the Sand theme (gold-on-sand is nearly the same hue) —
  // so the fill colour is theme.accent, which is always chosen to contrast
  // with background, instead of a fixed gold.
  List<Widget> _stars(double rating, DashboardTheme theme) {
    final fullStars = rating.floor();
    final hasHalf = rating - fullStars >= 0.5;
    return List.generate(2, (index) {
      if (index < fullStars) return Icon(Icons.star_rounded, color: theme.accent, size: 16);
      if (index == fullStars && hasHalf) return Icon(Icons.star_half_rounded, color: theme.accent, size: 16);
      return Icon(Icons.star_rounded, color: theme.accent.withValues(alpha: 0.3), size: 16);
    });
  }
}
