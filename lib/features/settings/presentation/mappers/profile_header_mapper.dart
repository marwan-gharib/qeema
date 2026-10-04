import 'package:qeema/features/auth/domain/entities/auth_user_entity.dart';
import 'package:qeema/features/settings/presentation/cubits/profile_header_cubit/profile_header_state.dart';

class ProfileHeaderMapper {
  const ProfileHeaderMapper._();

  static ProfileHeaderData fromEntity(AuthUserEntity entity) =>
      ProfileHeaderData(
        kind: entity.isAnonymous
            ? ProfileHeaderKind.guest
            : ProfileHeaderKind.user,
        displayName: _trimToNull(entity.displayName),
        email: _trimToNull(entity.email),
        avatarUrl: _trimToNull(entity.avatarUrl),
      );

  static String? _trimToNull(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? null : text;
  }
}
