import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/entity/photo.dart';
import 'package:frontend/providers/core/dio_provider.dart';
import 'package:frontend/services/photo_service.dart';

final photoServiceProvider = Provider<PhotoService>((ref) {
  return PhotoService(ref.watch(dioProvider));
});

final photoMetadataProvider = FutureProvider.family<PhotoDTO?, int>((
  ref,
  objectId,
) async {
  final service = ref.watch(photoServiceProvider);
  return service.getPhotoMetadata(objectId);
});
