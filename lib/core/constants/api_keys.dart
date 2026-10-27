/// JSON field names in payloads and responses that are not Supabase table
/// columns (ARCH-10): Supabase auth user-metadata keys and Edge Function
/// request/response keys.
abstract final class ApiKeys {
  // Supabase auth userMetadata.
  static const String fullName = 'full_name';
  static const String name = 'name';
  static const String avatarUrl = 'avatar_url';
  static const String picture = 'picture';

  // delete-account Edge Function.
  static const String userConfirmed = 'userConfirmed';
  static const String success = 'success';
  static const String partial = 'partial';
}
