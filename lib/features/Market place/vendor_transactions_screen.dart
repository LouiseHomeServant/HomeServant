import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';
import '../dashboard/models/property.dart';
import 'models/marketplace_order.dart';
import 'models/order_options.dart';
import 'models/vendor.dart';
import 'vendor_order_detail_screen.dart';

/// A ledger view of everything the vendor has sold — the same underlying
/// order items as Notifications, framed for tracking payouts rather than
/// spotting new orders. Reached from the Shop Profile screen.
class VendorTransactionsScreen extends StatelessWidget {
  const VendorTransactionsScreen({super.key, required this.theme});

  final DashboardTheme theme;

  @override
  Widget build(BuildContext context) {
    final entries = vendorOrderEntries(mockLoggedInVendor.businessName);
    final totalEarned = entries
        .where((e) => e.item.status == OrderItemStatus.completed)
        .fold<int>(0, (sum, e) => sum + e.item.subtotal);

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.foreground),
        title: Text('Transaction History', style: AppTextStyles.heading(color: theme.foreground, size: 18)),
      ),
      body: SafeArea(
        child: entries.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Your sales will show up here once you get an order.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body(color: theme.foreground.withValues(alpha: 0.6)),
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total from completed orders',
                          style: AppTextStyles.body(color: theme.onSurface.withValues(alpha: 0.6), size: 13),
                        ),
                        Text(
                          '₦${formatNaira(totalEarned)}',
                          style: AppTextStyles.heading(color: theme.onSurface, size: 17),
                        ),
                      ],
                    ),
                  ),
                  for (final entry in entries)
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => VendorOrderDetailScreen(theme: theme, entry: entry)),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.item.productName,
                                    style: AppTextStyles.body(color: theme.onSurface, size: 14, weight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${entry.order.customerName} · ${entry.order.paymentMethod.label}',
                                    style: AppTextStyles.body(color: theme.onSurface.withValues(alpha: 0.55), size: 12),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '₦${formatNaira(entry.item.subtotal)}',
                                  style: AppTextStyles.body(color: theme.onSurface, size: 13.5, weight: FontWeight.w700),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: entry.item.status.color.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    entry.item.status.label,
                                    style: AppTextStyles.body(color: entry.item.status.color, size: 10.5, weight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
