import 'package:flutter/material.dart';
import '../../core/responsive.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';
import '../../widgets/pill_button.dart';
import 'models/marketplace_product.dart';
import 'widgets/marketplace_product_gallery_screen.dart';

class MarketplaceProductDetailScreen extends StatefulWidget {
  const MarketplaceProductDetailScreen({super.key, required this.product, required this.theme, required this.onAddToCart});

  final MarketplaceProduct product;
  final DashboardTheme theme;
  final ValueChanged<MarketplaceProduct> onAddToCart;

  @override
  State<MarketplaceProductDetailScreen> createState() => _MarketplaceProductDetailScreenState();
}

class _MarketplaceProductDetailScreenState extends State<MarketplaceProductDetailScreen> {
  void _openGallery(int index) {
    final images = widget.product.displayImages;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MarketplaceProductGalleryScreen(images: images, initialIndex: index, title: widget.product.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = widget.theme;
    final images = product.displayImages;
    final inStock = product.stock > 0;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.foreground),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ResponsiveCenter(
            maxWidth: 640,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: images.isEmpty ? null : () => _openGallery(0),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: images.isNotEmpty
                            ? Image(image: images.first, fit: BoxFit.cover)
                            : DecoratedBox(
                                decoration: BoxDecoration(color: theme.surface),
                                child: Icon(product.icon, color: theme.onSurface.withValues(alpha: 0.5), size: 64),
                              ),
                      ),
                    ),
                  ),
                  if (images.length > 1) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 68,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () => _openGallery(index),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image(image: images[index], width: 68, height: 68, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text(product.name, style: AppTextStyles.heading(color: theme.foreground, size: 20)),
                  const SizedBox(height: 4),
                  Text(
                    product.vendorName,
                    style: AppTextStyles.body(color: theme.accent, size: 13.5, weight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, color: Colors.amber.shade600, size: 18),
                      const SizedBox(width: 4),
                      Text(product.rating.toString(), style: AppTextStyles.body(color: theme.foreground, size: 13.5)),
                      const SizedBox(width: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: (inStock ? Colors.green.shade600 : Colors.redAccent).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          inStock ? '${product.stock} left in stock' : 'Out of stock',
                          style: AppTextStyles.body(
                            color: inStock ? Colors.green.shade700 : Colors.redAccent,
                            size: 11.5,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(product.priceLabel, style: AppTextStyles.heading(color: theme.foreground, size: 24)),
                  const SizedBox(height: 20),
                  Text(
                    'Description',
                    style: AppTextStyles.body(color: theme.foreground.withValues(alpha: 0.55), size: 13, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    style: AppTextStyles.body(color: theme.foreground.withValues(alpha: 0.8), size: 14, weight: FontWeight.w400),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: PillButton(
                      label: inStock ? 'Add to Cart' : 'Out of Stock',
                      backgroundColor: theme.accent,
                      textColor: theme.onAccent,
                      onPressed: inStock ? () => widget.onAddToCart(product) : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
