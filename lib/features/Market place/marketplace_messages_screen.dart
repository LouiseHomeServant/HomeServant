import 'package:flutter/material.dart';
import '../../core/responsive.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';
import '../dashboard/chat_thread_screen.dart';
import 'models/marketplace_order.dart';

/// A customer's conversations with vendors — one per vendor they've
/// bought a pickup item from, since that's the only reason a customer
/// needs to message a vendor in this prototype. Reached from the
/// Marketplace home app bar.
class MarketplaceMessagesScreen extends StatelessWidget {
  const MarketplaceMessagesScreen({super.key, required this.theme});

  final DashboardTheme theme;

  List<String> get _vendors {
    final names = <String>{};
    for (final order in customerOrders) {
      names.addAll(order.pickupVendors);
    }
    return names.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final vendors = _vendors;
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.foreground),
        title: Text('Messages', style: AppTextStyles.heading(color: theme.foreground, size: 18)),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 640,
          child: vendors.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "You can message a vendor once you've bought a pickup item from them.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body(color: theme.foreground.withValues(alpha: 0.6)),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: vendors.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final vendorName = vendors[index];
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatThreadScreen(
                            theme: theme,
                            contactName: vendorName,
                            initialMessages: [
                              ChatMessage(
                                text: "Hi! Your order is ready whenever you'd like to come by for pickup.",
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
                              child: Icon(Icons.storefront_rounded, color: theme.accent),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                vendorName,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.body(color: theme.onSurface, size: 14, weight: FontWeight.w700),
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
      ),
    );
  }
}
