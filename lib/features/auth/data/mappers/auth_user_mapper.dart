import 'package:qeema/features/auth/data/models/auth_user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthUserMapper {
  const AuthUserMapper._();

  static AuthUserModel fromSupabaseUser(User user) => AuthUserModel(
    id: user.id,
    email: user.email ?? '',
    isAnonymous: user.isAnonymous,
    displayName: _displayName(user),
    avatarUrl: _avatarUrl(user),
  );

  /// Falls back to the email local part only — the localized generic name
  /// ("User") is applied by the UI, since this layer cannot localize.
  static String? _displayName(User user) {
    final metadata = user.userMetadata;
    final candidates = <Object?>[
      metadata?['full_name'],
      metadata?['name'],
      _emailLocalPart(user.email),
    ];
    for (final candidate in candidates) {
      final value = _trimToNull(candidate);
      if (value != null) return value;
    }
    return null;
  }

  static String? _avatarUrl(User user) =>
      _trimToNull(user.userMetadata?['avatar_url']) ??
      _trimToNull(user.userMetadata?['picture']);

  static String? _emailLocalPart(String? email) {
    final value = _trimToNull(email);
    if (value == null) return null;
    final separator = value.indexOf('@');
    if (separator < 0) return value;
    if (separator == 0) return null;
    return value.substring(0, separator);
  }

  static String? _trimToNull(Object? value) {
    final text = value is String ? value.trim() : '';
    return text.isEmpty ? null : text;
  }
}
