import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:frontend/models/entity/photo.dart';

class PhotoService {
  final Dio _dio;

  PhotoService(this._dio);

  Future<PhotoDTO> uploadPhoto(int objectId, File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    final response = await _dio.post(
      '/objects/$objectId/photo',
      data: formData,
    );
    return PhotoDTO.fromJson(response.data);
  }

  Future<PhotoDTO?> getPhotoMetadata(int objectId) async {
    try {
      final response = await _dio.get('/objects/$objectId/photo/metadata');
      return PhotoDTO.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<Uint8List> getPhoto(int objectId) async {
    final response = await _dio.get<List<int>>(
      '/objects/$objectId/photo',
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }

  Future<PhotoDTO> revertPhoto(int objectId) async {
    final response = await _dio.post('/objects/$objectId/photo/revert');
    return PhotoDTO.fromJson(response.data);
  }

  Future<void> deletePhoto(int objectId) async {
    await _dio.delete('/objects/$objectId/photo');
  }
}
