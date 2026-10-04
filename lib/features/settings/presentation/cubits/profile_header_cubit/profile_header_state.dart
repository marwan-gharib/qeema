enum ProfileHeaderKind { user, guest }

class ProfileHeaderData {
  const ProfileHeaderData({
    required this.kind,
    this.displayName,
    this.email,
    this.avatarUrl,
  });

  final ProfileHeaderKind kind;
  final String? displayName;
  final String? email;
  final String? avatarUrl;

  @override
  bool operator ==(Object other) =>
      other is ProfileHeaderData &&
      other.kind == kind &&
      other.displayName == displayName &&
      other.email == email &&
      other.avatarUrl == avatarUrl;

  @override
  int get hashCode => Object.hash(kind, displayName, email, avatarUrl);
}

sealed class ProfileHeaderState {
  const ProfileHeaderState();
}

final class ProfileHeaderLoading extends ProfileHeaderState {
  const ProfileHeaderLoading();
}

/// No reliable user (signed out, session expired, or the auth stream
/// failed) — the card renders its safe neutral variant instead of guessing
/// an account type.
final class ProfileHeaderSignedOut extends ProfileHeaderState {
  const ProfileHeaderSignedOut();
}

final class ProfileHeaderLoaded extends ProfileHeaderState {
  const ProfileHeaderLoaded(this.data);

  final ProfileHeaderData data;

  @override
  bool operator ==(Object other) =>
      other is ProfileHeaderLoaded && other.data == data;

  @override
  int get hashCode => data.hashCode;
}
