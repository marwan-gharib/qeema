import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/features/auth/data/mappers/auth_user_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  User buildUser({
    String? email,
    Map<String, dynamic>? metadata,
    bool isAnonymous = false,
  }) => User(
    id: 'user-1',
    appMetadata: const {},
    userMetadata: metadata,
    aud: 'authenticated',
    createdAt: '2024-01-01T00:00:00.000Z',
    email: email,
    isAnonymous: isAnonymous,
  );

  group('displayName fallback', () {
    test('prefers full_name over name and email', () {
      final model = AuthUserMapper.fromSupabaseUser(
        buildUser(
          email: 'jane@example.com',
          metadata: const {'full_name': 'Jane Doe', 'name': 'Other'},
        ),
      );

      expect(model.displayName, 'Jane Doe');
    });

    test('falls back to name when full_name is missing', () {
      final model = AuthUserMapper.fromSupabaseUser(
        buildUser(email: 'jane@example.com', metadata: const {'name': 'Jane'}),
      );

      expect(model.displayName, 'Jane');
    });

    test('falls back to the email local part', () {
      final model = AuthUserMapper.fromSupabaseUser(
        buildUser(email: 'jane@example.com'),
      );

      expect(model.displayName, 'jane');
    });

    test('returns null when nothing resolves', () {
      final model = AuthUserMapper.fromSupabaseUser(buildUser());

      expect(model.displayName, isNull);
    });

    test('trims values and treats blanks as missing', () {
      final model = AuthUserMapper.fromSupabaseUser(
        buildUser(
          email: '  jane@example.com  ',
          metadata: const {'full_name': '   ', 'name': ''},
        ),
      );

      expect(model.displayName, 'jane');
    });

    test('ignores non-string metadata values', () {
      final model = AuthUserMapper.fromSupabaseUser(
        buildUser(
          email: 'jane@example.com',
          metadata: const {
            'full_name': 42,
            'name': <String>['x'],
          },
        ),
      );

      expect(model.displayName, 'jane');
    });

    test('keeps Arabic and emoji names untouched', () {
      final model = AuthUserMapper.fromSupabaseUser(
        buildUser(metadata: const {'full_name': 'محمد علي 😀'}),
      );

      expect(model.displayName, 'محمد علي 😀');
    });

    test('returns null when the email local part is empty', () {
      final model = AuthUserMapper.fromSupabaseUser(
        buildUser(email: '@example.com'),
      );

      expect(model.displayName, isNull);
    });
  });

  group('avatarUrl fallback', () {
    test('uses avatar_url from metadata', () {
      final model = AuthUserMapper.fromSupabaseUser(
        buildUser(
          metadata: const {
            'avatar_url': ' https://example.com/a.png ',
            'picture': 'https://example.com/b.png',
          },
        ),
      );

      expect(model.avatarUrl, 'https://example.com/a.png');
    });

    test('falls back to picture', () {
      final model = AuthUserMapper.fromSupabaseUser(
        buildUser(metadata: const {'picture': 'https://example.com/b.png'}),
      );

      expect(model.avatarUrl, 'https://example.com/b.png');
    });

    test('returns null when absent, blank, or non-string', () {
      expect(AuthUserMapper.fromSupabaseUser(buildUser()).avatarUrl, isNull);
      expect(
        AuthUserMapper.fromSupabaseUser(
          buildUser(metadata: const {'avatar_url': '   '}),
        ).avatarUrl,
        isNull,
      );
      expect(
        AuthUserMapper.fromSupabaseUser(
          buildUser(metadata: const {'avatar_url': 7}),
        ).avatarUrl,
        isNull,
      );
    });
  });

  test('maps id, email, and isAnonymous through', () {
    final model = AuthUserMapper.fromSupabaseUser(
      buildUser(email: null, isAnonymous: true),
    );

    expect(model.id, 'user-1');
    expect(model.email, '');
    expect(model.isAnonymous, isTrue);
    expect(model.toEntity().isAnonymous, isTrue);
    expect(model.toEntity().displayName, model.displayName);
    expect(model.toEntity().avatarUrl, model.avatarUrl);
  });
}
