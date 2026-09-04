/// The signed-in vendor's shop profile, shown on the Marketplace vendor
/// dashboard. This prototype has no vendor auth backend — logging in with
/// any email/password lands on this one demo shop, same as tenant/landlord
/// login accepts any credentials. Mutable (not const) so Edit Profile can
/// update it in place.
class VendorProfile {
  VendorProfile({
    required this.businessName,
    required this.ownerName,
    required this.email,
    required this.category,
    required this.state,
    required this.rating,
    this.logoPath,
    this.bankName,
    this.accountNumber,
    this.accountName,
  });

  String businessName;
  String ownerName;
  String email;
  String category;
  String state;
  final double rating;

  /// Locally-picked logo image path — see `imageProviderForPath` in
  /// upload_picker.dart to render it.
  String? logoPath;

  /// Payout bank details. All null until the vendor fills in "Payout
  /// Account" on Edit Profile — there's no payment backend, so this is
  /// display-only, gated by the disclaimer shown there.
  String? bankName;
  String? accountNumber;
  String? accountName;
}

/// The current vendor session. A plain mutable global — this prototype has
/// no backend/auth, so there's exactly one vendor identity in the app.
final mockLoggedInVendor = VendorProfile(
  businessName: 'Comfort Home Furniture',
  ownerName: 'Ngozi Umeh',
  email: 'vendor@comforthome.ng',
  category: 'Furniture',
  state: 'Lagos',
  rating: 4.7,
);
