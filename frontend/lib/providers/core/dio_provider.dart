import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/api_client.dart';
import 'package:frontend/services/auth_interceptor.dart';
import 'package:frontend/providers/core/storage_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);
  final dio = ApiClient().dio;

  dio.interceptors.add(AuthInterceptor(storage));

  return dio;
});
