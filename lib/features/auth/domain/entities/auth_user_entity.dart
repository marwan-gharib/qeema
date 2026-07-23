class AuthUserEntity {
  const AuthUserEntity({
    required this.id,
    required this.email,
    this.isAnonymous = false,
  });
  final String id;
  final String email;
  final bool isAnonymous;
}
