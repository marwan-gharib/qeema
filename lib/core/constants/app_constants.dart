class AppConstants {
  const AppConstants._();

  static const int connectionTimeoutSeconds = 30;
  static const int pageSize = 20;
  static const Duration cacheDuration = Duration(hours: 1);
  static const Duration marketPriceCacheDuration = Duration(hours: 12);

  static const String biometricEnabledKey = 'biometric_enabled';
  static const String lastFullSyncAtKey = 'last_full_sync_at';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String appLocaleKey = 'app_locale';
  static const String appThemeModeKey = 'app_theme_mode';
  static const String deleteAccountConfirmationPhrase = 'DELETE';
}
