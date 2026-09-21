import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/login/auth_constants.dart';
import 'package:frontend/providers/core/dio_provider.dart';
import 'package:frontend/providers/core/storage_provider.dart';
import 'package:frontend/providers/object/photo_providers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/models/entity/photo.dart';
import 'package:frontend/services/error_interceptor.dart';

class PhotoSection extends ConsumerStatefulWidget {
  final int objectId;
  final bool canEdit;

  const PhotoSection({
    super.key,
    required this.objectId,
    required this.canEdit,
  });

  @override
  ConsumerState<PhotoSection> createState() => _PhotoSectionState();
}

class _PhotoSectionState extends ConsumerState<PhotoSection> {
  bool _isBusy = false;
  String? _authToken;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final storage = ref.read(secureStorageProvider);
    final token = await storage.read(key: authTokenKey);
    if (mounted) setState(() => _authToken = token);
  }

  Future<void> _pickAndUpload(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return;

    setState(() => _isBusy = true);
    try {
      final service = ref.read(photoServiceProvider);
      await service.uploadPhoto(widget.objectId, File(picked.path));
      ref.invalidate(photoMetadataProvider(widget.objectId));
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Fotoğraf yüklendi.')));
      }
    } catch (e) {
      final message = e is AppException ? e.message : 'Fotoğraf yüklenemedi.';
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _showSourcePicker() async {
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
    if (source != null) _pickAndUpload(source);
  }

  Future<void> _revert() async {
    setState(() => _isBusy = true);
    try {
      final service = ref.read(photoServiceProvider);
      await service.revertPhoto(widget.objectId);
      ref.invalidate(photoMetadataProvider(widget.objectId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Önceki fotoğrafa dönüldü.')),
        );
      }
    } catch (e) {
      final message = e is AppException ? e.message : 'Geri alınamadı.';
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fotoğrafı Sil'),
        content: const Text('Bu fotoğrafı silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isBusy = true);
    try {
      final service = ref.read(photoServiceProvider);
      await service.deletePhoto(widget.objectId);
      ref.invalidate(photoMetadataProvider(widget.objectId));
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Fotoğraf silindi.')));
      }
    } catch (e) {
      final message = e is AppException ? e.message : 'Silinemedi.';
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoAsync = ref.watch(photoMetadataProvider(widget.objectId));

    return photoAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Fotoğraf yüklenemedi: $err'),
      ),
      data: (photo) => _buildBody(photo),
    );
  }

  Widget _buildBody(PhotoDTO? photo) {
    final baseUrl = ref.read(dioProvider).options.baseUrl;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (photo != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _authToken == null
                  ? const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Image.network(
                      '$baseUrl${photo.photoUrl}?t=${photo.uploadedAt.millisecondsSinceEpoch}',
                      headers: {'Authorization': 'Bearer $_authToken'},
                      fit: BoxFit.cover,
                      height: 200,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stack) => const SizedBox(
                        height: 200,
                        child: Center(child: Icon(Icons.broken_image)),
                      ),
                    ),
            )
          else
            ListTile(
              leading: const Icon(Icons.image_outlined, color: Colors.grey),
              title: const Text('Fotoğraf yok'),
            ),
          if (widget.canEdit) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isBusy ? null : _showSourcePicker,
                    icon: const Icon(Icons.camera_alt),
                    label: Text(
                      photo == null ? 'Fotoğraf Ekle' : 'Yeniden Çek',
                    ),
                  ),
                ),
                if (photo != null && photo.hasPrevious) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _isBusy ? null : _revert,
                    icon: const Icon(Icons.undo),
                    tooltip: 'Önceki fotoğrafa dön',
                  ),
                ],
                if (photo != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _isBusy ? null : _confirmDelete,
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Fotoğrafı sil',
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
