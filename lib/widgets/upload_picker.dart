import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

const _imageExtensions = {'jpg', 'jpeg', 'png', 'heic', 'heif', 'webp', 'gif', 'bmp'};

/// Result of a successful upload pick, regardless of source.
class PickedUpload {
  const PickedUpload({required this.path, required this.fileName, required this.isImage});

  final String path;
  final String fileName;
  final bool isImage;
}

/// Lets the user upload any document — a photo from their camera roll, or
/// any file (PDF, Word doc, image, etc.) from Files. Used by every upload
/// affordance across the signup flow (profile photo, certificate of
/// ownership, ID/verification documents).
Future<PickedUpload?> pickUpload(BuildContext context) async {
  final source = await showModalBottomSheet<_UploadSource>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library_rounded, color: AppColors.navy),
            title: Text('Choose from Camera Roll', style: AppTextStyles.body(color: AppColors.navy)),
            onTap: () => Navigator.pop(context, _UploadSource.gallery),
          ),
          ListTile(
            leading: const Icon(Icons.folder_rounded, color: AppColors.navy),
            title: Text('Choose from Files', style: AppTextStyles.body(color: AppColors.navy)),
            onTap: () => Navigator.pop(context, _UploadSource.files),
          ),
        ],
      ),
    ),
  );

  switch (source) {
    case _UploadSource.gallery:
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (picked == null) return null;
      return PickedUpload(path: picked.path, fileName: picked.name, isImage: true);
    case _UploadSource.files:
      final result = await FilePicker.pickFiles();
      final file = result?.files.single;
      if (file?.path == null) return null;
      final extension = (file!.extension ?? '').toLowerCase();
      return PickedUpload(path: file.path!, fileName: file.name, isImage: _imageExtensions.contains(extension));
    case null:
      return null;
  }
}

enum _UploadSource { gallery, files }
