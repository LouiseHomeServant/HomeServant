import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/dashboard_theme.dart';
import '../models/marketplace_product.dart';

class MarketplaceProductCard extends StatelessWidget {
  const MarketplaceProductCard({
    super.key,
    required this.product,
    required this.theme,
    required this.onAddToCart,
    required this.onOpen,
  });

  final MarketplaceProduct product;
  final DashboardTheme theme;
  final VoidCallback onAddToCart;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final images = product.displayImages;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onOpen,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 11,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: images.isNotEmpty
                    ? Image(image: images.first, fit: BoxFit.cover)
                    : DecoratedBox(
                        decoration: BoxDecoration(color: theme.onSurface.withValues(alpha: 0.06)),
                        child: Icon(product.icon, color: theme.onSurface.withValues(alpha: 0.55), size: 36),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body(color: theme.onSurface, size: 14, weight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              product.vendorName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body(color: theme.onSurface.withValues(alpha: 0.55), size: 12, weight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.star_rounded, color: Colors.amber.shade600, size: 15),
                const SizedBox(width: 2),
                Text(product.rating.toString(), style: AppTextStyles.body(color: theme.onSurface.withValues(alpha: 0.7), size: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product.priceLabel,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body(color: theme.onSurface, size: 14.5, weight: FontWeight.w800),
                  ),
                ),
                GestureDetector(
                  onTap: onAddToCart,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: theme.accent, shape: BoxShape.circle),
                    child: Icon(Icons.add_shopping_cart_rounded, color: theme.onAccent, size: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
