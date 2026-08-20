import 'package:dio/dio.dart';

class AppException implements Exception {
  final int? statusCode;
  final String message;

  AppException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;

    if (response != null && response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      final message = data['message'] as String? ?? 'Bir şeyler ters gitti.';

      final appException = AppException(
        message: message,
        statusCode: response.statusCode,
      );

      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: appException,
          response: response,
          type: err.type,
        ),
      );
      return;
    }

    final appException = AppException(message: _fallbackMessage(err));

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: appException,
        type: err.type,
      ),
    );
  }

  String _fallbackMessage(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Bağlantı zaman aşımına uğradı. ağ bağlantınızı kontrol edin.';
      case DioExceptionType.connectionError:
        return 'Sunucuya erişilemedi..';
      default:
        return 'Beklenmedik bir sorun meydana geldi..';
    }
  }
}
