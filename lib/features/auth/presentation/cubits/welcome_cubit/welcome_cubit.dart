import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/features/auth/domain/usecases/continue_as_guest_usecase.dart';
import 'package:qeema/features/auth/presentation/cubits/welcome_cubit/welcome_state.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit(this._continueAsGuestUseCase) : super(const WelcomeInitial());
  final ContinueAsGuestUseCase _continueAsGuestUseCase;

  Future<void> continueAsGuest() async {
    emit(const WelcomeGuestLoading());
    final result = await _continueAsGuestUseCase();
    result.fold(
      onSuccess: (_) => emit(const WelcomeGuestSuccess()),
      onFailure: (failure) => emit(WelcomeGuestFailure(failure)),
    );
  }
}
