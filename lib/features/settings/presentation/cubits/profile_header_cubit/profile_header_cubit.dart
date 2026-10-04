import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/auth/domain/entities/auth_user_entity.dart';
import 'package:qeema/features/auth/domain/usecases/watch_auth_user_usecase.dart';
import 'package:qeema/features/settings/presentation/cubits/profile_header_cubit/profile_header_state.dart';
import 'package:qeema/features/settings/presentation/mappers/profile_header_mapper.dart';

class ProfileHeaderCubit extends Cubit<ProfileHeaderState> {
  ProfileHeaderCubit(this._watchAuthUser)
    : super(const ProfileHeaderLoading()) {
    _subscription = _watchAuthUser().listen(
      _onResult,
      onError: (Object _) => _resolvePendingState(),
      onDone: _resolvePendingState,
    );
  }

  final WatchAuthUserUseCase _watchAuthUser;
  late final StreamSubscription<ApiResult<AuthUserEntity?>> _subscription;

  void _onResult(ApiResult<AuthUserEntity?> result) {
    if (isClosed) return;
    result.fold(
      onSuccess: (user) {
        if (isClosed) return;
        if (user == null) {
          emit(const ProfileHeaderSignedOut());
        } else {
          emit(ProfileHeaderLoaded(ProfileHeaderMapper.fromEntity(user)));
        }
      },
      // A failed read must not blank out data already on screen — only an
      // unresolved skeleton is downgraded to the neutral state.
      onFailure: (_) => _resolvePendingState(),
    );
  }

  void _resolvePendingState() {
    if (isClosed) return;
    if (state == const ProfileHeaderLoading()) {
      emit(const ProfileHeaderSignedOut());
    }
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await super.close();
  }
}
