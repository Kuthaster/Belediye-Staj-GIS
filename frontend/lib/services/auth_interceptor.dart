import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/models/login/auth_constants.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;

  AuthInterceptor(this.secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await secureStorage.read(key: authTokenKey);

    debugPrint('Auth token found: ${token != null && token.isNotEmpty}');

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      debugPrint('Authorization header attached');
    }

    handler.next(options);
  }
}
