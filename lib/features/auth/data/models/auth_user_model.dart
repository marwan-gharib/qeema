import 'package:qeema/core/constants/api_keys.dart';
import 'package:qeema/features/auth/domain/entities/auth_user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Auth user as stored/passed inside the data layer; expose via [toEntity].
class AuthUserModel {
  const AuthUserModel({
    required this.id,
    required this.email,
    this.isAnonymous = false,
    this.displayName,
    this.avatarUrl,
  });

  /// Parses a Supabase auth [User] at the data-layer boundary.
  factory AuthUserModel.fromSupabaseUser(User user) => AuthUserModel(
    id: user.id,
    email: user.email ?? '',
    isAnonymous: user.isAnonymous,
    displayName: _displayName(user),
    avatarUrl: _avatarUrl(user),
  );

  final String id;
  final String email;
  final bool isAnonymous;
  final String? displayName;
  final String? avatarUrl;

  /// Falls back to the email local part only — the localized generic name
  /// ("User") is applied by the UI, since this layer cannot localize.
  static String? _displayName(User user) {
    final metadata = user.userMetadata;
    final candidates = <Object?>[
      metadata?[ApiKeys.fullName],
      metadata?[ApiKeys.name],
      _emailLocalPart(user.email),
    ];
    for (final candidate in candidates) {
      final value = _trimToNull(candidate);
      if (value != null) return value;
    }
    return null;
  }

  static String? _avatarUrl(User user) =>
      _trimToNull(user.userMetadata?[ApiKeys.avatarUrl]) ??
      _trimToNull(user.userMetadata?[ApiKeys.picture]);

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

  AuthUserEntity toEntity() => AuthUserEntity(
    id: id,
    email: email,
    isAnonymous: isAnonymous,
    displayName: displayName,
    avatarUrl: avatarUrl,
  );
}
