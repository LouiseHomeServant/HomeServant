import 'package:flutter/material.dart';
import '../models/marketplace_order.dart';
import '../models/marketplace_product.dart';

/// Shows the ordered product's own photo (looked up in [marketplaceCatalog]
/// by [OrderItem.productId]) so order rows read like a real receipt instead
/// of a generic icon. Falls back to [OrderItem.icon] when the product has
/// since been removed from the catalog and has no photo to show.
class OrderItemThumbnail extends StatelessWidget {
  const OrderItemThumbnail({
    super.key,
    required this.item,
    required this.iconColor,
    this.backgroundColor,
    this.size = 44,
    this.borderRadius = 12,
  });

  final OrderItem item;
  final Color iconColor;
  final Color? backgroundColor;
  final double size;
  final double borderRadius;

  MarketplaceProduct? get _product {
    for (final product in marketplaceCatalog) {
      if (product.id == item.productId) return product;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final images = _product?.displayImages ?? const [];
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: size,
        height: size,
        color: backgroundColor ?? iconColor.withValues(alpha: 0.12),
        alignment: Alignment.center,
        child: images.isEmpty
            ? Icon(item.icon, color: iconColor, size: size * 0.5)
            : Image(image: images.first, fit: BoxFit.cover, width: size, height: size),
      ),
    );
  }
}
