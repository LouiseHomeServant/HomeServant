import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/responsive.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';
import '../../widgets/pill_button.dart';
import '../../widgets/pill_text_field.dart';
import '../../widgets/upload_picker.dart';
import 'models/marketplace_order.dart';
import 'models/marketplace_product.dart';
import 'models/vendor.dart';

const _businessCategories = [
  'Furniture',
  'Home Appliances',
  'Electronics',
  'Fittings & Fixtures',
  'Décor',
  'Tools & Equipment',
  'Other',
];

/// Lets the vendor update their shop's public details, logo, and payout
/// bank account. Renaming the business cascades to every product they've
/// already listed and every past order line item, so "My Products" and
/// order history don't silently stop matching them.
class VendorEditProfileScreen extends StatefulWidget {
  const VendorEditProfileScreen({super.key, required this.theme});

  final DashboardTheme theme;

  @override
  State<VendorEditProfileScreen> createState() => _VendorEditProfileScreenState();
}

class _VendorEditProfileScreenState extends State<VendorEditProfileScreen> {
  late final _businessName = TextEditingController(text: mockLoggedInVendor.businessName);
  late final _ownerName = TextEditingController(text: mockLoggedInVendor.ownerName);
  late final _email = TextEditingController(text: mockLoggedInVendor.email);
  late final _bankName = TextEditingController(text: mockLoggedInVendor.bankName ?? '');
  late final _accountNumber = TextEditingController(text: mockLoggedInVendor.accountNumber ?? '');
  late final _accountName = TextEditingController(text: mockLoggedInVendor.accountName ?? '');
  late String _category = mockLoggedInVendor.category;
  late String? _logoPath = mockLoggedInVendor.logoPath;

  @override
  void dispose() {
    _businessName.dispose();
    _ownerName.dispose();
    _email.dispose();
    _bankName.dispose();
    _accountNumber.dispose();
    _accountName.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) setState(() => _logoPath = picked.path);
  }

  Future<void> _pickCategory() async {
    final theme = widget.theme;
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: theme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final option in _businessCategories)
              ListTile(
                title: Text(option, style: AppTextStyles.body(color: theme.onSurface)),
                trailing: option == _category ? Icon(Icons.check, color: theme.accent) : null,
                onTap: () => Navigator.pop(context, option),
              ),
          ],
        ),
      ),
    );
    if (result != null) setState(() => _category = result);
  }

  void _save() {
    final newName = _businessName.text.trim();
    final oldName = mockLoggedInVendor.businessName;
    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Business name cannot be empty')));
      return;
    }
    if (newName != oldName) {
      for (final product in marketplaceCatalog) {
        if (product.vendorName == oldName) product.vendorName = newName;
      }
      for (final order in customerOrders) {
        for (final item in order.items) {
          if (item.vendorName == oldName) item.vendorName = newName;
        }
      }
    }
    mockLoggedInVendor
      ..businessName = newName
      ..ownerName = _ownerName.text.trim()
      ..email = _email.text.trim()
      ..category = _category
      ..logoPath = _logoPath
      ..bankName = _bankName.text.trim().isEmpty ? null : _bankName.text.trim()
      ..accountNumber = _accountNumber.text.trim().isEmpty ? null : _accountNumber.text.trim()
      ..accountName = _accountName.text.trim().isEmpty ? null : _accountName.text.trim();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shop profile updated')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.foreground),
        title: Text('Edit Shop Profile', style: AppTextStyles.heading(color: theme.foreground, size: 18)),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 640,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickLogo,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: theme.accent.withValues(alpha: 0.15),
                        backgroundImage: _logoPath != null ? imageProviderForPath(_logoPath!) : null,
                        child: _logoPath == null ? Icon(Icons.storefront_rounded, color: theme.accent, size: 38) : null,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.accent,
                            shape: BoxShape.circle,
                            border: Border.all(color: theme.background, width: 2),
                          ),
                          child: Icon(Icons.camera_alt_rounded, size: 16, color: theme.onAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: _pickLogo,
                  child: Text('Change Logo', style: AppTextStyles.body(color: theme.accent, weight: FontWeight.w700, size: 13)),
                ),
              ),
              const SizedBox(height: 20),
              _Field(theme: theme, label: 'Business Name', controller: _businessName),
              const SizedBox(height: 16),
              _Field(theme: theme, label: "Owner's Full Name", controller: _ownerName),
              const SizedBox(height: 16),
              _Field(theme: theme, label: 'Email Address', controller: _email, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _Dropdown(theme: theme, label: 'Business Category', value: _category, onTap: _pickCategory),
              const SizedBox(height: 28),
              Text('Payout Account', style: AppTextStyles.heading(color: theme.foreground, size: 16)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Payouts are sent to this account only after an order has been verified and marked '
                  'completed — not immediately at purchase.',
                  style: AppTextStyles.body(color: theme.foreground.withValues(alpha: 0.75), size: 12.5),
                ),
              ),
              const SizedBox(height: 16),
              _Field(theme: theme, label: 'Bank Name', controller: _bankName),
              const SizedBox(height: 16),
              _Field(theme: theme, label: 'Account Number', controller: _accountNumber, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _Field(theme: theme, label: 'Account Name', controller: _accountName),
              const SizedBox(height: 28),
              PillButton(label: 'Save Changes', backgroundColor: theme.accent, textColor: theme.onAccent, onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.theme, required this.label, required this.controller, this.keyboardType});

  final DashboardTheme theme;
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body(color: theme.foreground, weight: FontWeight.w600, size: 13.5)),
        const SizedBox(height: 8),
        PillTextField(
          hint: '',
          controller: controller,
          keyboardType: keyboardType,
          fillColor: theme.surface,
          textColor: theme.onSurface,
        ),
      ],
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({required this.theme, required this.label, required this.value, required this.onTap});

  final DashboardTheme theme;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body(color: theme.foreground, weight: FontWeight.w600, size: 13.5)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(28)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: AppTextStyles.body(color: theme.onSurface, size: 15)),
                Icon(Icons.keyboard_arrow_down_rounded, color: theme.onSurface.withValues(alpha: 0.6)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
