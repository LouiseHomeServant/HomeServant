import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';
import '../dashboard/chat_thread_screen.dart';
import '../dashboard/models/property.dart';
import 'models/marketplace_order.dart';
import 'models/order_options.dart';
import 'widgets/order_item_thumbnail.dart';

/// Full detail on one item a vendor sold — reached from either the
/// Notifications or Transaction History screen, so both stay a thin list
/// over this one shared view. Shows the fulfillment method the customer
/// chose and, for delivery, their contact details (a vendor coordinating
/// pickup instead messages the customer, reusing the chat thread already
/// built for the customer-side pickup flow).
class VendorOrderDetailScreen extends StatefulWidget {
  const VendorOrderDetailScreen({super.key, required this.theme, required this.entry});

  final DashboardTheme theme;
  final VendorOrderEntry entry;

  @override
  State<VendorOrderDetailScreen> createState() => _VendorOrderDetailScreenState();
}

class _VendorOrderDetailScreenState extends State<VendorOrderDetailScreen> {
  late OrderItemStatus _status = widget.entry.item.status;

  void _setStatus(OrderItemStatus status) {
    setState(() {
      widget.entry.item.status = status;
      _status = status;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Marked as ${status.label}')));
  }

  void _messageCustomer() {
    final order = widget.entry.order;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatThreadScreen(
          theme: widget.theme,
          contactName: order.customerName,
          initialMessages: [
            ChatMessage(
              text: 'Hi, when would be a good time for me to pick up the ${widget.entry.item.productName}?',
              fromMe: false,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final entry = widget.entry;
    final order = entry.order;
    final item = entry.item;
    final isDelivery = item.fulfillment == FulfillmentMethod.delivery;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.foreground),
        title: Text('Order Details', style: AppTextStyles.heading(color: theme.foreground, size: 18)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(18)),
              child: Row(
                children: [
                  OrderItemThumbnail(
                    item: item,
                    iconColor: theme.accent,
                    backgroundColor: theme.accent.withValues(alpha: 0.12),
                    size: 52,
                    borderRadius: 14,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          style: AppTextStyles.body(color: theme.onSurface, size: 15, weight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Qty ${item.quantity} · ₦${formatNaira(item.price)} each',
                          style: AppTextStyles.body(color: theme.onSurface.withValues(alpha: 0.6), size: 12.5),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _status.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _status.label,
                      style: AppTextStyles.body(color: _status.color, size: 11, weight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _DetailCard(
              theme: theme,
              rows: [
                _DetailRow(theme: theme, label: 'Order ID', value: order.id),
                _DetailRow(theme: theme, label: 'Order Date', value: _formatDate(order.date)),
                _DetailRow(theme: theme, label: 'Payment Method', value: order.paymentMethod.label),
                _DetailRow(theme: theme, label: 'Fulfillment', value: item.fulfillment.label),
                _DetailRow(theme: theme, label: 'Item Total', value: '₦${formatNaira(item.subtotal)}', showDivider: false),
              ],
            ),
            const SizedBox(height: 16),
            _DetailCard(
              theme: theme,
              title: 'Customer',
              rows: [
                _DetailRow(theme: theme, label: 'Name', value: order.customerName),
                if (isDelivery) ...[
                  _DetailRow(
                    theme: theme,
                    label: 'Phone',
                    value: order.customerPhone.isEmpty ? 'Not provided' : order.customerPhone,
                  ),
                  _DetailRow(
                    theme: theme,
                    label: 'Delivery Address',
                    value: order.customerAddress.isEmpty ? 'Not provided' : order.customerAddress,
                    showDivider: false,
                  ),
                ] else
                  _DetailRow(theme: theme, label: 'Fulfillment', value: 'Customer will pick up', showDivider: false),
              ],
            ),
            if (!isDelivery) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _messageCustomer,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: theme.accent, width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  minimumSize: const Size.fromHeight(0),
                ),
                icon: Icon(Icons.chat_bubble_outline_rounded, color: theme.accent, size: 18),
                label: Text(
                  'Message Customer',
                  style: AppTextStyles.body(color: theme.accent, weight: FontWeight.w700, size: 14),
                ),
              ),
            ],
            if (_status == OrderItemStatus.pending) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _setStatus(OrderItemStatus.cancelled),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.redAccent, width: 1.2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: Text(
                        'Cancel Order',
                        style: AppTextStyles.button(color: Colors.redAccent, size: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _setStatus(OrderItemStatus.completed),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.accent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: Text('Mark Completed', style: AppTextStyles.button(color: theme.onAccent, size: 14)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.theme, required this.rows, this.title});

  final DashboardTheme theme;
  final List<_DetailRow> rows;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!, style: AppTextStyles.body(color: theme.onSurface, size: 13, weight: FontWeight.w700)),
            const SizedBox(height: 8),
          ],
          for (final row in rows) row,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.theme, required this.label, required this.value, this.showDivider = true});

  final DashboardTheme theme;
  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.body(color: theme.onSurface.withValues(alpha: 0.55), size: 13)),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.body(color: theme.onSurface, size: 13.5, weight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(color: theme.onSurface.withValues(alpha: 0.1), height: 1),
      ],
    );
  }
}

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _formatDate(DateTime date) => '${date.day} ${_months[date.month - 1]} ${date.year}';
