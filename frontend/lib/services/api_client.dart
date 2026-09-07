import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/services/auth_interceptor.dart';

const authTokenKey = 'auth_token';
const secureStorage = FlutterSecureStorage();

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  late final Dio dio;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:8080/api',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(AuthInterceptor(secureStorage));
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }
}

final Dio dioClient = ApiClient().dio;
