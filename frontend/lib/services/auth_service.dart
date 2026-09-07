import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/exception/api_exception.dart';
import 'package:frontend/models/login/login_request.dart';
import 'package:frontend/models/login/login_response.dart';
import 'package:frontend/services/api_client.dart';

class AuthService {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthService({Dio? dio, FlutterSecureStorage? storage})
    : _dio = dio ?? dioClient,
      _storage = storage ?? const FlutterSecureStorage();

  Future<LoginResponse> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email.trim(), password: password);

      final response = await _dio.post('/auth/login', data: request.toJson());

      final loginResponse = LoginResponse.fromJson(response.data);

      await _storage.write(key: authTokenKey, value: loginResponse.token);

      return loginResponse;
    } on DioException catch (e) {
      throw ApiException('E-posta veya şifre hatalı', e.response?.statusCode);
    }
  }
}
