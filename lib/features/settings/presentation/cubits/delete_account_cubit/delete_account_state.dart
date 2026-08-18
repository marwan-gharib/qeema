import 'package:qeema/core/error/failures.dart';

sealed class DeleteAccountState {
  const DeleteAccountState();
}

final class DeleteAccountInitial extends DeleteAccountState {
  const DeleteAccountInitial();
}

final class DeleteAccountDeleting extends DeleteAccountState {
  const DeleteAccountDeleting();
}

final class DeleteAccountSuccess extends DeleteAccountState {
  const DeleteAccountSuccess();
}

final class DeleteAccountFailure extends DeleteAccountState {
  const DeleteAccountFailure(this.failure);
  final Failure failure;
}
