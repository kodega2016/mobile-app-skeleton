import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ErrorInterceptor extends Interceptor {
  final _logger = Logger();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final errorMessage = _handleError(err);
    _logger.e('API Error: $errorMessage');
    
    handler.next(err);
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      
      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode);
      
      case DioExceptionType.cancel:
        return 'Request cancelled';
      
      case DioExceptionType.connectionError:
        return 'No internet connection';
      
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Resource not found';
      case 500:
        return 'Internal server error';
      case 503:
        return 'Service unavailable';
      default:
        return 'Error occurred: $statusCode';
    }
  }
}