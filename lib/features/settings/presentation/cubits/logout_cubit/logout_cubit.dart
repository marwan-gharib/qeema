import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/features/settings/domain/usecases/is_current_user_anonymous_usecase.dart';
import 'package:qeema/features/settings/domain/usecases/logout_usecase.dart';
import 'package:qeema/features/settings/presentation/cubits/logout_cubit/logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit(this._logoutUseCase, this._isCurrentUserAnonymous)
    : super(const LogoutInitial());
  final LogoutUseCase _logoutUseCase;
  final IsCurrentUserAnonymousUseCase _isCurrentUserAnonymous;

  /// Reads the live account type so the UI can show the right
  /// confirmation dialog (deletion warning for guests only).
  bool isCurrentUserAnonymous() => _isCurrentUserAnonymous();

  Future<void> logout() async {
    if (isClosed) return;
    if (state is LogoutLoading) return;
    emit(const LogoutLoading());
    final result = await _logoutUseCase();
    if (isClosed) return;
    result.fold(
      onSuccess: (_) => emit(const LogoutSuccess()),
      onFailure: (failure) => emit(LogoutFailure(failure)),
    );
  }
}
