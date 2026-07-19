class EnvConfig {
  EnvConfig._();

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabasepublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );
}
