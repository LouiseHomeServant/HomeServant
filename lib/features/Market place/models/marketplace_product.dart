import 'package:flutter/material.dart';
import '../../../widgets/upload_picker.dart';
import '../../dashboard/models/property.dart';
import 'order_options.dart';

/// A listing sold by a vendor on the Home Servant Marketplace — building
/// materials, furniture, appliances, and other move-in essentials, as
/// opposed to the properties themselves.
class MarketplaceProduct {
  MarketplaceProduct({
    required this.id,
    required this.name,
    required this.vendorName,
    required this.category,
    required this.price,
    required this.rating,
    required this.icon,
    required this.description,
    required this.stock,
    this.images = const [],
    this.imageAssets = const [],
    this.video,
    this.fulfillmentOptions = const {FulfillmentMethod.delivery, FulfillmentMethod.pickup},
  });

  final String id;
  final String name;
  String vendorName;
  final String category;
  final int price;
  final double rating;

  /// Fallback tile shown when there are no [images]/[imageAssets] — every
  /// product has one regardless, since a vendor's own photos take a moment
  /// to load and this is what the space renders in the meantime.
  final IconData icon;

  final String description;

  /// How many units the vendor has available. Shown on the product detail
  /// screen; doesn't decrement on checkout in this prototype.
  final int stock;

  /// Photos a vendor picked at runtime when listing this product (2-5,
  /// enforced by the listing form). Empty for the seeded mock catalog,
  /// which uses [imageAssets] instead.
  final List<PickedUpload> images;

  /// Bundled asset photos for the seeded mock catalog. Empty for anything
  /// a vendor lists through the app, which populates [images] instead.
  final List<String> imageAssets;

  /// One optional product video, also picked when listing.
  final PickedUpload? video;

  /// Whether the vendor offers delivery, pickup, or both for this item —
  /// set at listing time so the customer cart only offers what's actually
  /// available for each product.
  final Set<FulfillmentMethod> fulfillmentOptions;

  /// Every photo for this product, in display order, regardless of
  /// whether it came from a vendor's live pick or the bundled mock seed.
  List<ImageProvider> get displayImages {
    if (images.isNotEmpty) return images.map((i) => i.imageProvider).toList();
    return imageAssets.map<ImageProvider>(AssetImage.new).toList();
  }

  String get priceLabel => '₦${formatNaira(price)}';
}

/// One of the category filter chips on the marketplace screen. Kept
/// separate from [MarketplaceProduct.category] values only in name — every
/// product's category is one of these.
const marketplaceCategories = [
  'All',
  'Furniture',
  'Home Appliances',
  'Electronics',
  'Fittings & Fixtures',
  'Décor',
  'Tools & Equipment',
];

final mockMarketplaceProducts = [
  MarketplaceProduct(
    id: 'mp2',
    name: '3-Seater Leather Sofa',
    vendorName: 'Comfort Home Furniture',
    category: 'Furniture',
    price: 245000,
    rating: 4.8,
    icon: Icons.weekend_rounded,
    stock: 6,
    imageAssets: ['assets/images/marketplace/sofa.jpg'],
    description: 'Sturdy hardwood frame with a soft leather finish. Delivered flat-packed with free assembly.',
  ),
  MarketplaceProduct(
    id: 'mp3',
    name: '1.5HP Split Unit Air Conditioner',
    vendorName: 'CoolBreeze Electronics',
    category: 'Home Appliances',
    price: 380000,
    rating: 4.5,
    icon: Icons.ac_unit_rounded,
    stock: 14,
    imageAssets: ['assets/images/marketplace/ac_unit.jpg'],
    description: 'Energy-efficient inverter AC with remote control, ideal for a standard bedroom or living room.',
  ),
  MarketplaceProduct(
    id: 'mp4',
    name: '55" 4K Smart Television',
    vendorName: 'CoolBreeze Electronics',
    category: 'Electronics',
    price: 420000,
    rating: 4.7,
    icon: Icons.tv_rounded,
    stock: 9,
    imageAssets: ['assets/images/marketplace/tv.jpg'],
    description: 'Ultra HD display with built-in streaming apps and voice remote.',
  ),
  MarketplaceProduct(
    id: 'mp5',
    name: 'Chrome Bathroom Tap Set',
    vendorName: 'Prime Fittings Ltd',
    category: 'Fittings & Fixtures',
    price: 32000,
    rating: 4.4,
    icon: Icons.plumbing_rounded,
    stock: 52,
    imageAssets: ['assets/images/marketplace/tap.jpg'],
    description: 'Rust-resistant chrome-plated tap set for sinks and basins, includes fitting hardware.',
  ),
  MarketplaceProduct(
    id: 'mp6',
    name: 'Abstract Canvas Wall Art (Set of 3)',
    vendorName: 'Studio Decor Lagos',
    category: 'Décor',
    price: 45000,
    rating: 4.9,
    icon: Icons.image_rounded,
    stock: 20,
    imageAssets: ['assets/images/marketplace/wall_art.jpg'],
    description: 'Hand-stretched canvas prints that add a modern touch to any living space.',
  ),
  MarketplaceProduct(
    id: 'mp7',
    name: 'Cordless Drill Driver Kit',
    vendorName: 'ToolMart Nigeria',
    category: 'Tools & Equipment',
    price: 58000,
    rating: 4.3,
    icon: Icons.handyman_rounded,
    stock: 27,
    imageAssets: ['assets/images/marketplace/drill.jpg'],
    description: '18V cordless drill with two batteries, charger, and a 30-piece bit set.',
  ),
  MarketplaceProduct(
    id: 'mp8',
    name: 'Queen Size Orthopaedic Mattress',
    vendorName: 'Comfort Home Furniture',
    category: 'Furniture',
    price: 165000,
    rating: 4.6,
    icon: Icons.bed_rounded,
    stock: 11,
    imageAssets: ['assets/images/marketplace/mattress.jpg'],
    description: 'High-density foam mattress with breathable cover, designed for back support.',
  ),
];

/// The live product catalog — seeded from [mockMarketplaceProducts] but
/// mutable, so a vendor listing or removing a product (from the vendor
/// dashboard) is immediately reflected in the customer-facing marketplace,
/// since both read from this same list.
final List<MarketplaceProduct> marketplaceCatalog = List.of(mockMarketplaceProducts);
