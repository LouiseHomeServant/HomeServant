import 'package:flutter/material.dart';
import 'order_options.dart';

/// One line item within a [MarketplaceOrder] — a snapshot of the product
/// at purchase time (name, vendor, price) so the order stays meaningful
/// even if the vendor later edits or removes the listing. Mutable because
/// the selling vendor updates [status] as they fulfill it, and the app
/// tracks whether it's been seen on the vendor's Notifications screen.
class OrderItem {
  OrderItem({
    required this.productId,
    required this.productName,
    required this.vendorName,
    required this.icon,
    required this.price,
    required this.quantity,
    required this.fulfillment,
    this.status = OrderItemStatus.pending,
    this.notificationRead = false,
  });

  final String productId;
  final String productName;
  String vendorName;
  final IconData icon;
  final int price;
  final int quantity;
  final FulfillmentMethod fulfillment;
  OrderItemStatus status;
  bool notificationRead;

  int get subtotal => price * quantity;
}

/// A completed marketplace purchase, recorded the moment a customer pays
/// at checkout — including a snapshot of their contact details, since a
/// vendor fulfilling a delivery item needs to reach them. Mutable + global
/// like [marketplaceCatalog]: this prototype has no backend, so an
/// in-memory list stands in for both a customer's orders table and (once
/// filtered by vendor name) every vendor's own orders/notifications/
/// transactions.
class MarketplaceOrder {
  const MarketplaceOrder({
    required this.id,
    required this.date,
    required this.items,
    required this.paymentMethod,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
  });

  final String id;
  final DateTime date;
  final List<OrderItem> items;
  final PaymentMethod paymentMethod;
  final String customerName;
  final String customerPhone;
  final String customerAddress;

  int get total => items.fold(0, (sum, item) => sum + item.subtotal);

  /// Vendors in this order the customer chose pickup from — only these are
  /// worth messaging, since a delivery item doesn't need coordinating.
  List<String> get pickupVendors =>
      items.where((item) => item.fulfillment == FulfillmentMethod.pickup).map((item) => item.vendorName).toSet().toList();
}

/// One [OrderItem] paired with the [MarketplaceOrder] it belongs to — a
/// vendor only ever cares about their own items within an order, but still
/// needs the parent order's id/date/payment method/customer contact to
/// show a useful notification, order detail, or transaction record.
class VendorOrderEntry {
  const VendorOrderEntry({required this.order, required this.item});

  final MarketplaceOrder order;
  final OrderItem item;
}

/// Every item sold by [vendorName] across all customer orders, newest
/// first — the shared source for a vendor's dashboard, Notifications and
/// Transaction History screens, so they never drift out of sync with each
/// other or with what a customer actually sees in their own Order History.
List<VendorOrderEntry> vendorOrderEntries(String vendorName) {
  final entries = [
    for (final order in customerOrders)
      for (final item in order.items)
        if (item.vendorName == vendorName) VendorOrderEntry(order: order, item: item),
  ];
  entries.sort((a, b) => b.order.date.compareTo(a.order.date));
  return entries;
}

/// Seeded with a few past orders — across different vendors, fulfillment
/// methods and statuses — so the customer's Order History and every
/// vendor's dashboard/notifications/transactions have something to show
/// right away; checkout appends to this list.
final List<MarketplaceOrder> customerOrders = [
  MarketplaceOrder(
    id: 'mo1',
    date: DateTime.now().subtract(const Duration(days: 1)),
    paymentMethod: PaymentMethod.card,
    customerName: 'Tunde Bakare',
    customerPhone: '0803 555 1122',
    customerAddress: '12 Allen Avenue, Ikeja, Lagos',
    items: [
      OrderItem(
        productId: 'mp2',
        productName: '3-Seater Leather Sofa',
        vendorName: 'Comfort Home Furniture',
        icon: Icons.weekend_rounded,
        price: 245000,
        quantity: 1,
        fulfillment: FulfillmentMethod.pickup,
      ),
    ],
  ),
  MarketplaceOrder(
    id: 'mo2',
    date: DateTime.now().subtract(const Duration(days: 3)),
    paymentMethod: PaymentMethod.bankTransfer,
    customerName: 'Amaka Nwosu',
    customerPhone: '0807 222 9981',
    customerAddress: '4 Marina Road, Onikan, Lagos',
    items: [
      OrderItem(
        productId: 'mp8',
        productName: 'Queen Size Orthopaedic Mattress',
        vendorName: 'Comfort Home Furniture',
        icon: Icons.bed_rounded,
        price: 165000,
        quantity: 1,
        fulfillment: FulfillmentMethod.pickup,
        status: OrderItemStatus.completed,
        notificationRead: true,
      ),
    ],
  ),
  MarketplaceOrder(
    id: 'mo3',
    date: DateTime.now().subtract(const Duration(days: 9)),
    paymentMethod: PaymentMethod.card,
    customerName: 'Femi Adeyemi',
    customerPhone: '0701 884 3320',
    customerAddress: '9 Bode Thomas Street, Surulere, Lagos',
    items: [
      OrderItem(
        productId: 'mp3',
        productName: '1.5HP Split Unit Air Conditioner',
        vendorName: 'CoolBreeze Electronics',
        icon: Icons.ac_unit_rounded,
        price: 380000,
        quantity: 1,
        fulfillment: FulfillmentMethod.delivery,
        status: OrderItemStatus.completed,
        notificationRead: true,
      ),
    ],
  ),
  MarketplaceOrder(
    id: 'mo4',
    date: DateTime.now().subtract(const Duration(days: 12)),
    paymentMethod: PaymentMethod.bankTransfer,
    customerName: 'Halima Yusuf',
    customerPhone: '0906 442 7710',
    customerAddress: '21 Awolowo Way, Ikeja, Lagos',
    items: [
      OrderItem(
        productId: 'mp4',
        productName: '55" 4K Smart Television',
        vendorName: 'CoolBreeze Electronics',
        icon: Icons.tv_rounded,
        price: 420000,
        quantity: 1,
        fulfillment: FulfillmentMethod.delivery,
        status: OrderItemStatus.cancelled,
        notificationRead: true,
      ),
    ],
  ),
];
