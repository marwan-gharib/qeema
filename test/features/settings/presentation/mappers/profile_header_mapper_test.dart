import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/features/auth/domain/entities/auth_user_entity.dart';
import 'package:qeema/features/settings/presentation/cubits/profile_header_cubit/profile_header_state.dart';
import 'package:qeema/features/settings/presentation/mappers/profile_header_mapper.dart';

void main() {
  group('ProfileHeaderMapper.fromEntity', () {
    test('maps a signed-in user and trims its fields', () {
      final data = ProfileHeaderMapper.fromEntity(
        const AuthUserEntity(
          id: 'user-1',
          email: ' jane@example.com ',
          displayName: ' Jane Doe ',
          avatarUrl: ' https://example.com/a.png ',
        ),
      );

      expect(data.kind, ProfileHeaderKind.user);
      expect(data.displayName, 'Jane Doe');
      expect(data.email, 'jane@example.com');
      expect(data.avatarUrl, 'https://example.com/a.png');
    });

    test('maps an anonymous user to the guest kind', () {
      final data = ProfileHeaderMapper.fromEntity(
        const AuthUserEntity(id: 'anon-1', email: '', isAnonymous: true),
      );

      expect(data.kind, ProfileHeaderKind.guest);
      expect(data.displayName, isNull);
      expect(data.email, isNull);
      expect(data.avatarUrl, isNull);
    });

    test('treats blank fields as missing', () {
      final data = ProfileHeaderMapper.fromEntity(
        const AuthUserEntity(
          id: 'user-1',
          email: '   ',
          displayName: '  ',
          avatarUrl: '',
        ),
      );

      expect(data.displayName, isNull);
      expect(data.email, isNull);
      expect(data.avatarUrl, isNull);
    });

    test('gives equal data equal values so the UI can skip rebuilds', () {
      const entity = AuthUserEntity(
        id: 'user-1',
        email: 'jane@example.com',
        displayName: 'Jane Doe',
      );

      final first = ProfileHeaderMapper.fromEntity(entity);
      final second = ProfileHeaderMapper.fromEntity(entity);

      expect(first, second);
      expect(first.hashCode, second.hashCode);
      expect(
        ProfileHeaderLoaded(first),
        ProfileHeaderLoaded(second),
      );
    });
  });
}
