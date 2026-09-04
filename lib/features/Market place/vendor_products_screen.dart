import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';
import 'add_product_screen.dart';
import 'models/marketplace_product.dart';
import 'models/vendor.dart';
import 'vendor_dashboard_screen.dart';
import 'vendor_profile_screen.dart';
import 'widgets/vendor_bottom_nav.dart';

/// The vendor's own product catalog — list what's currently for sale, add
/// a new listing, or remove one. Reads and writes [marketplaceCatalog]
/// directly, so changes here show up in the customer marketplace too.
class VendorProductsScreen extends StatefulWidget {
  const VendorProductsScreen({super.key, required this.theme});

  final DashboardTheme theme;

  @override
  State<VendorProductsScreen> createState() => _VendorProductsScreenState();
}

class _VendorProductsScreenState extends State<VendorProductsScreen> {
  List<MarketplaceProduct> get _myProducts =>
      marketplaceCatalog.where((p) => p.vendorName == mockLoggedInVendor.businessName).toList();

  void _onNavTap(int index) {
    if (index == 1) return;
    final theme = widget.theme;
    final screen = index == 0 ? VendorDashboardScreen(theme: theme) : VendorProfileScreen(theme: theme);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> _addProduct() async {
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => AddProductScreen(theme: widget.theme)),
    );
    if (added == true && mounted) setState(() {});
  }

  void _removeProduct(MarketplaceProduct product) {
    setState(() => marketplaceCatalog.removeWhere((p) => p.id == product.id));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name} removed')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final products = _myProducts;

    return VendorTabScaffold(
      theme: theme,
      currentIndex: 1,
      onNavTap: _onNavTap,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('My Products', style: AppTextStyles.heading(color: theme.foreground, size: 20)),
                  GestureDetector(
                    onTap: _addProduct,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(color: theme.accent, borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: theme.onAccent, size: 17),
                          const SizedBox(width: 4),
                          Text('Add', style: AppTextStyles.body(color: theme.onAccent, weight: FontWeight.w700, size: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (products.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Center(
                  child: Text(
                    "You haven't listed any products yet",
                    style: AppTextStyles.body(color: theme.foreground.withValues(alpha: 0.6)),
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 130),
              sliver: SliverList.builder(
                itemCount: products.length,
                itemBuilder: (context, index) => _VendorProductTile(
                  theme: theme,
                  product: products[index],
                  onRemove: () => _removeProduct(products[index]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _VendorProductTile extends StatelessWidget {
  const _VendorProductTile({required this.theme, required this.product, required this.onRemove});

  final DashboardTheme theme;
  final MarketplaceProduct product;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 56,
              height: 56,
              child: product.displayImages.isNotEmpty
                  ? Image(image: product.displayImages.first, fit: BoxFit.cover)
                  : DecoratedBox(
                      decoration: BoxDecoration(color: theme.onSurface.withValues(alpha: 0.06)),
                      child: Icon(product.icon, color: theme.onSurface.withValues(alpha: 0.55), size: 26),
                    ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: AppTextStyles.body(color: theme.onSurface, size: 14, weight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(product.category, style: AppTextStyles.body(color: theme.onSurface.withValues(alpha: 0.55), size: 12)),
                const SizedBox(height: 4),
                Text(product.priceLabel, style: AppTextStyles.body(color: theme.onSurface, size: 13, weight: FontWeight.w700)),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: Icon(Icons.delete_outline_rounded, color: Colors.redAccent.withValues(alpha: 0.8), size: 20),
          ),
        ],
      ),
    );
  }
}
