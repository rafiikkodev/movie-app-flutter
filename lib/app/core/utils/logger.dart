import 'package:flutter/foundation.dart';

/// Centralized logging service untuk production-ready app
/// Di release mode, semua log akan di-disable otomatis
class LoggerService {
  static void info(String message, [dynamic data]) {
    if (kDebugMode) {
      debugPrint('ℹ️ INFO: $message ${data != null ? '| Data: $data' : ''}');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('❌ ERROR: $message ${error != null ? '| Error: $error' : ''}');
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    }
  }

  static void warning(String message, [dynamic data]) {
    if (kDebugMode) {
      debugPrint('⚠️ WARNING: $message ${data != null ? '| Data: $data' : ''}');
    }
  }

  static void success(String message, [dynamic data]) {
    if (kDebugMode) {
      debugPrint('✅ SUCCESS: $message ${data != null ? '| Data: $data' : ''}');
    }
  }
}
