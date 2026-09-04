import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';
import '../dashboard/chat_thread_screen.dart';
import 'models/marketplace_order.dart';
import 'models/order_options.dart';
import 'models/vendor.dart';

/// The vendor's conversations with customers — one per pickup order, since
/// that's the only case a vendor needs to coordinate with a customer in
/// this prototype. Reached from the vendor dashboard's app bar.
class VendorMessagesScreen extends StatelessWidget {
  const VendorMessagesScreen({super.key, required this.theme});

  final DashboardTheme theme;

  List<VendorOrderEntry> get _pickupOrders => vendorOrderEntries(
    mockLoggedInVendor.businessName,
  ).where((e) => e.item.fulfillment == FulfillmentMethod.pickup).toList();

  @override
  Widget build(BuildContext context) {
    final orders = _pickupOrders;
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.foreground),
        title: Text('Messages', style: AppTextStyles.heading(color: theme.foreground, size: 18)),
      ),
      body: SafeArea(
        child: orders.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "You can message a customer once they've bought a pickup item from you.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body(color: theme.foreground.withValues(alpha: 0.6)),
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: orders.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final entry = orders[index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatThreadScreen(
                          theme: theme,
                          contactName: entry.order.customerName,
                          initialMessages: [
                            ChatMessage(
                              text: 'Hi, when would be a good time for me to pick up the ${entry.item.productName}?',
                              fromMe: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(18)),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: theme.accent.withValues(alpha: 0.25),
                            child: Icon(Icons.person, color: theme.accent),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.order.customerName,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.body(color: theme.onSurface, size: 14, weight: FontWeight.w700),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  entry.item.productName,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.body(color: theme.onSurface.withValues(alpha: 0.6), size: 12.5),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded, color: theme.onSurface.withValues(alpha: 0.3)),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
