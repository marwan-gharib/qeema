import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/features/settings/domain/usecases/delete_account_usecase.dart';
import 'package:qeema/features/settings/presentation/cubits/delete_account_cubit/delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit(this._deleteAccountUseCase)
    : super(const DeleteAccountInitial());
  final DeleteAccountUseCase _deleteAccountUseCase;

  Future<void> deleteAccount() async {
    emit(const DeleteAccountDeleting());
    final result = await _deleteAccountUseCase();
    result.fold(
      onSuccess: (_) => emit(const DeleteAccountSuccess()),
      onFailure: (failure) => emit(DeleteAccountFailure(failure)),
    );
  }
}
