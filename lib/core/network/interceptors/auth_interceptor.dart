import 'package:dio/dio.dart';

import '../../di/injection.dart';
import '../../services/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final _secureStorage = getIt<SecureStorageService>();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getToken();
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle token refresh or logout
      _handleUnauthorized();
    }
    handler.next(err);
  }

  Future<void> _handleUnauthorized() async {
    // Clear token and navigate to login
    await _secureStorage.deleteToken();
    // Add navigation logic here
  }
}