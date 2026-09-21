import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPickerField extends StatelessWidget {
  final File? value;
  final ValueChanged<File?> onChanged;

  const PhotoPickerField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Future<void> _pick(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked != null) {
      onChanged(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (value == null) {
      return OutlinedButton.icon(
        onPressed: () => _pick(context),
        icon: const Icon(Icons.camera_alt),
        label: const Text('Fotoğraf Ekle (İsteğe Bağlı)'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(value!, height: 140, fit: BoxFit.cover),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () => _pick(context),
                icon: const Icon(Icons.refresh),
                label: const Text('Değiştir'),
              ),
            ),
            TextButton.icon(
              onPressed: () => onChanged(null),
              icon: const Icon(Icons.close),
              label: const Text('Kaldır'),
            ),
          ],
        ),
      ],
    );
  }
}
