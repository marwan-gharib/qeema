import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qeema/core/constants/app_constants.dart';

abstract final class AppEnv {
  static String? _supabaseUrl;
  static String? _supabasePublishableKey;

  static bool get isLoaded =>
      _supabaseUrl != null && _supabasePublishableKey != null;

  static Future<void> load() async {
    if (!dotenv.isInitialized) await dotenv.load();
    final value = dotenv.env[AppConstants.supabaseUrl]?.trim();
    if (value == null || value.isEmpty) {
      _supabaseUrl = null;
      _supabasePublishableKey = null;
      throw StateError(
        'AppEnv: ${AppConstants.supabaseUrl} is missing or empty in .env. '
        'Copy .env.example, set the value, and rebuild.',
      );
    }
    _supabaseUrl = value;

    final supabasePublishableKey = dotenv
        .env[AppConstants.supabasePublishableKey]
        ?.trim();
    if (supabasePublishableKey == null || supabasePublishableKey.isEmpty) {
      _supabaseUrl = null;
      _supabasePublishableKey = null;
      throw StateError(
        'AppEnv: ${AppConstants.supabasePublishableKey} is missing or empty in .env. '
        'Copy .env.example, set the value, and rebuild.',
      );
    }
    _supabasePublishableKey = supabasePublishableKey;
  }

  static String get supabaseUrl {
    final value = _supabaseUrl;
    if (value == null || value.isEmpty) {
      throw StateError(
        'AppEnv: base URL read before load(). Call AppEnv.load() in main() '
        '(or AppEnv.debugSeed in tests) first.',
      );
    }
    return value;
  }

  static String get supabasePublishableKey {
    final value = _supabasePublishableKey;
    if (value == null || value.isEmpty) {
      throw StateError(
        'AppEnv: Google Server Client ID read before load(). Call AppEnv.load() in main() '
        '(or AppEnv.debugSeed in tests) first.',
      );
    }
    return value;
  }

  @visibleForTesting
  static void debugSeed({String? supabaseUrl, String? supabasePublishableKey}) {
    if (supabaseUrl != null) _supabaseUrl = supabaseUrl;
    if (supabasePublishableKey != null) {
      _supabasePublishableKey = supabasePublishableKey;
    }
  }

  @visibleForTesting
  static void reset() {
    _supabaseUrl = null;
    _supabasePublishableKey = null;
  }
}
