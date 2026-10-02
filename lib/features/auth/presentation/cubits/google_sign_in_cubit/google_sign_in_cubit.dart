import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:qeema/features/auth/presentation/cubits/google_sign_in_cubit/google_sign_in_state.dart';

class GoogleSignInCubit extends Cubit<GoogleSignInState> {
  GoogleSignInCubit(this._googleSignInUseCase)
    : super(const GoogleSignInInitialState());
  final GoogleSignInUseCase _googleSignInUseCase;

  Future<void> googleSignIn() async {
    emit(const GoogleSignInLoadingState());
    final result = await _googleSignInUseCase();
    result.fold(
      onSuccess: (_) => emit(const GoogleSignInSuccessState()),
      onFailure: (failure) => emit(GoogleSignInFailureState(failure)),
    );
  }
}
