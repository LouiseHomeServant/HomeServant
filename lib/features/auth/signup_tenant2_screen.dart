import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/user_role.dart';
import '../../widgets/home_servant_logo.dart';
import '../../widgets/pill_button.dart';
import '../../widgets/pill_text_field.dart';
import '../../widgets/themed_scaffold.dart';

class SignupTenant2Screen extends StatefulWidget {
  const SignupTenant2Screen({super.key, required this.onFinish});

  final VoidCallback onFinish;

  @override
  State<SignupTenant2Screen> createState() => _SignupTenant2ScreenState();
}

class _SignupTenant2ScreenState extends State<SignupTenant2Screen> {
  static const _idOptions = ['NIN', "Driver's License", "Voter's Card", 'International Passport'];
  static const _role = UserRole.tenant;

  String _address = '15 Seyi Coker Street, AGEGE';
  String _identification = 'NIN';
  File? _photo;

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) {
      setState(() => _photo = File(picked.path));
    }
  }

  Future<void> _editAddress() async {
    final controller = TextEditingController(text: _address);
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Your address', style: AppTextStyles.heading(color: AppColors.navy, size: 18)),
            const SizedBox(height: 14),
            PillTextField(hint: 'Enter your address', controller: controller),
            const SizedBox(height: 16),
            PillButton(
              label: 'Save',
              backgroundColor: AppColors.navy,
              textColor: Colors.white,
              onPressed: () => Navigator.pop(context, controller.text.trim()),
            ),
          ],
        ),
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() => _address = result);
    }
  }

  Future<void> _pickIdentification() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _idOptions
              .map((option) => ListTile(
                    title: Text(option, style: AppTextStyles.body(color: AppColors.navy)),
                    trailing: option == _identification ? const Icon(Icons.check, color: AppColors.gold) : null,
                    onTap: () => Navigator.pop(context, option),
                  ))
              .toList(),
        ),
      ),
    );
    if (result != null) {
      setState(() => _identification = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    const panelColor = Color(0xFF1B3255);
    return ThemedScaffold(
      role: _role,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Center(child: HomeServantLogo(role: _role, iconSize: 56, textSize: 24)),
          const SizedBox(height: 36),
          GestureDetector(
            onTap: _pickPhoto,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(color: panelColor, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: _role.accent.withValues(alpha: 0.3),
                    backgroundImage: _photo != null ? FileImage(_photo!) : null,
                    child: _photo == null ? Icon(Icons.person, size: 40, color: _role.foreground) : null,
                  ),
                  const SizedBox(height: 12),
                  Text('Add a Photo', style: AppTextStyles.body(color: _role.accent, weight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          LabeledDropdownField(
            label: 'Upload your Address',
            value: _address,
            labelColor: _role.foreground,
            onTap: _editAddress,
          ),
          const SizedBox(height: 22),
          LabeledDropdownField(
            label: 'Means of Identification',
            value: _identification,
            labelColor: _role.foreground,
            onTap: _pickIdentification,
          ),
          const SizedBox(height: 32),
          PillButton(
            label: 'Continue',
            backgroundColor: _role.accent,
            textColor: Colors.white,
            onPressed: widget.onFinish,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
