import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized logging service
class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  late final Logger _logger;

  factory LoggerService() {
    return _instance;
  }

  LoggerService._internal() {
    _logger = Logger(
      filter: _CustomLogFilter(),
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
    );
  }

  /// Log debug message
  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log info message
  void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning message
  void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error message
  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal error
  void fatal(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}

/// Custom log filter - only log in debug mode
class _CustomLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return kDebugMode;
  }
}

/// Global logger instance
final logger = LoggerService();