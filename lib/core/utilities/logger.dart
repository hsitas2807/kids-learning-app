import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class AppLogger {
  AppLogger._();

  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      _log(LogLevel.debug, message, tag: tag);
    }
  }

  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      _log(LogLevel.info, message, tag: tag);
    }
  }

  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      _log(LogLevel.warning, message, tag: tag);
    }
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (kDebugMode) {
      _log(LogLevel.error, message, tag: tag);
      if (error != null) {
        debugPrint('  Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('  Stack: $stackTrace');
      }
    }
  }

  static void _log(LogLevel level, String message, {String? tag}) {
    final prefix = tag != null ? '[$tag] ' : '';
    final levelStr = level.name.toUpperCase().padRight(7);
    debugPrint('[$levelStr] $prefix$message');
  }
}
