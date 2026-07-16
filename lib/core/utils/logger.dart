import 'dart:developer';

class Logger {
  const Logger._();

  static void info(String message) {
    log('[INFO] $message');
  }

  static void warning(String message) {
    log('[WARNING] $message');
  }

  static void error(String message) {
    log('[ERROR] $message');
  }
}
