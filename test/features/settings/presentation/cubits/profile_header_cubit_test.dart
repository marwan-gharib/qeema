import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/auth/domain/entities/auth_user_entity.dart';
import 'package:qeema/features/settings/presentation/cubits/profile_header_cubit/profile_header_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/profile_header_cubit/profile_header_state.dart';

import '../../../../helpers/mocks.dart';

void main() {
  const googleUser = AuthUserEntity(
    id: 'user-1',
    email: 'jane@example.com',
    displayName: 'Jane Doe',
    avatarUrl: 'https://example.com/a.png',
  );
  const guestUser = AuthUserEntity(id: 'anon-1', email: '', isAnonymous: true);

  late StreamController<ApiResult<AuthUserEntity?>> controller;
  late ProfileHeaderCubit cubit;

  setUp(() {
    controller = StreamController<ApiResult<AuthUserEntity?>>();
    cubit = ProfileHeaderCubit(
      MockWatchAuthUserUseCase()..result = controller.stream,
    );
  });

  tearDown(() async {
    if (!cubit.isClosed) await cubit.close();
    if (!controller.isClosed) await controller.close();
  });

  test('starts in the loading state', () {
    expect(cubit.state, isA<ProfileHeaderLoading>());
  });

  test('emits loaded state for a signed-in user', () async {
    controller.add(const Success<AuthUserEntity?>(googleUser));
    await pumpEventQueue();

    expect(
      cubit.state,
      const ProfileHeaderLoaded(
        ProfileHeaderData(
          kind: ProfileHeaderKind.user,
          displayName: 'Jane Doe',
          email: 'jane@example.com',
          avatarUrl: 'https://example.com/a.png',
        ),
      ),
    );
  });

  test('emits loaded state for an anonymous user', () async {
    controller.add(const Success<AuthUserEntity?>(guestUser));
    await pumpEventQueue();

    expect(
      cubit.state,
      const ProfileHeaderLoaded(
        ProfileHeaderData(kind: ProfileHeaderKind.guest),
      ),
    );
  });

  test('emits signed out when the stream yields no user', () async {
    controller.add(const Success<AuthUserEntity?>(null));
    await pumpEventQueue();

    expect(cubit.state, isA<ProfileHeaderSignedOut>());
  });

  test('keeps the loaded state when a later read fails', () async {
    controller.add(const Success<AuthUserEntity?>(googleUser));
    await pumpEventQueue();
    controller.add(const ResultFailure<AuthUserEntity?>(CacheFailure()));
    await pumpEventQueue();

    expect(cubit.state, isA<ProfileHeaderLoaded>());
  });

  test('resolves to signed out when the stream fails while loading', () async {
    controller.addError(Exception('auth stream failed'));
    await pumpEventQueue();

    expect(cubit.state, isA<ProfileHeaderSignedOut>());
  });

  test('resolves to signed out when the stream closes while loading', () async {
    await controller.close();
    await pumpEventQueue();

    expect(cubit.state, isA<ProfileHeaderSignedOut>());
  });

  test('ignores stream results after close', () async {
    await cubit.close();

    controller.add(const Success<AuthUserEntity?>(googleUser));
    await pumpEventQueue();

    expect(cubit.isClosed, isTrue);
  });
}
