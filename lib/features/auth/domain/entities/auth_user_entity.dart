class AuthUserEntity {
  const AuthUserEntity({
    required this.id,
    required this.email,
    this.isAnonymous = false,
    this.displayName,
    this.avatarUrl,
  });
  final String id;
  final String email;
  final bool isAnonymous;
  final String? displayName;
  final String? avatarUrl;
}
