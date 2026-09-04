import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';
import '../../widgets/upload_picker.dart';
import '../dashboard/models/property.dart';
import 'models/marketplace_order.dart';
import 'models/marketplace_product.dart';
import 'models/order_options.dart';
import 'models/vendor.dart';
import 'vendor_messages_screen.dart';
import 'vendor_notifications_screen.dart';
import 'vendor_order_detail_screen.dart';
import 'vendor_products_screen.dart';
import 'vendor_profile_screen.dart';
import 'widgets/vendor_bottom_nav.dart';

/// The signed-in vendor's home base — a snapshot of their shop's products,
/// orders and revenue. Reached after [VendorLoginScreen]; the bottom nav
/// hands off to the separate [VendorProductsScreen] and
/// [VendorProfileScreen] screens.
class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key, required this.theme});

  final DashboardTheme theme;

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  void _onNavTap(int index) {
    if (index == 0) return;
    final screen = index == 1 ? VendorProductsScreen(theme: widget.theme) : VendorProfileScreen(theme: widget.theme);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> _openNotifications() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => VendorNotificationsScreen(theme: widget.theme)),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final vendor = mockLoggedInVendor;
    final myProducts = marketplaceCatalog.where((p) => p.vendorName == vendor.businessName).toList();
    final orderEntries = vendorOrderEntries(vendor.businessName);
    final revenue = orderEntries
        .where((e) => e.item.status != OrderItemStatus.cancelled)
        .fold<int>(0, (sum, e) => sum + e.item.subtotal);
    final unreadCount = orderEntries.where((e) => !e.item.notificationRead).length;

    return VendorTabScaffold(
      theme: theme,
      currentIndex: 0,
      onNavTap: _onNavTap,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome back,', style: AppTextStyles.body(color: theme.foreground.withValues(alpha: 0.6), size: 13)),
                        Text(
                          vendor.businessName,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.heading(color: theme.foreground, size: 20),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: _openNotifications,
                            icon: Icon(Icons.notifications_none_rounded, color: theme.foreground),
                          ),
                          if (unreadCount > 0)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: theme.accent, shape: BoxShape.circle),
                                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                child: Text(
                                  '$unreadCount',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.body(color: theme.onAccent, size: 9, weight: FontWeight.w800),
                                ),
                              ),
                            ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => VendorMessagesScreen(theme: theme)),
                        ),
                        icon: Icon(Icons.chat_bubble_outline_rounded, color: theme.foreground),
                      ),
                      const SizedBox(width: 4),
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: theme.accent.withValues(alpha: 0.15),
                        backgroundImage: vendor.logoPath != null ? imageProviderForPath(vendor.logoPath!) : null,
                        child: vendor.logoPath == null
                            ? Icon(Icons.storefront_rounded, color: theme.accent, size: 22)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Row(
                children: [
                  _StatCard(theme: theme, label: 'Products', value: '${myProducts.length}'),
                  const SizedBox(width: 12),
                  _StatCard(theme: theme, label: 'Orders', value: '${orderEntries.length}'),
                  const SizedBox(width: 12),
                  _StatCard(theme: theme, label: 'Revenue', value: '₦${formatNaira(revenue)}', small: true),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
              child: Text('Recent Orders', style: AppTextStyles.heading(color: theme.foreground, size: 17)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 130),
            sliver: orderEntries.isEmpty
                ? SliverToBoxAdapter(
                    child: Text(
                      'Orders for your shop will show up here.',
                      style: AppTextStyles.body(color: theme.foreground.withValues(alpha: 0.55), size: 13),
                    ),
                  )
                : SliverList.builder(
                    itemCount: orderEntries.length,
                    itemBuilder: (context, index) {
                      final entry = orderEntries[index];
                      return GestureDetector(
                        onTap: () async {
                          entry.item.notificationRead = true;
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => VendorOrderDetailScreen(theme: theme, entry: entry)),
                          );
                          setState(() {});
                        },
                        child: _OrderTile(theme: theme, entry: entry),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.theme, required this.label, required this.value, this.small = false});

  final DashboardTheme theme;
  final String label;
  final String value;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.heading(color: theme.onSurface, size: small ? 15 : 20),
            ),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.body(color: theme.onSurface.withValues(alpha: 0.55), size: 12)),
          ],
        ),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.theme, required this.entry});

  final DashboardTheme theme;
  final VendorOrderEntry entry;

  @override
  Widget build(BuildContext context) {
    final item = entry.item;
    final order = entry.order;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName, style: AppTextStyles.body(color: theme.onSurface, size: 14, weight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  '${order.customerName} · ${_formatDate(order.date)}',
                  style: AppTextStyles.body(color: theme.onSurface.withValues(alpha: 0.55), size: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₦${formatNaira(item.subtotal)}',
                style: AppTextStyles.body(color: theme.onSurface, size: 13.5, weight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: item.status.color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                child: Text(item.status.label, style: AppTextStyles.body(color: item.status.color, size: 10.5, weight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${date.day} ${months[date.month - 1]}';
}
