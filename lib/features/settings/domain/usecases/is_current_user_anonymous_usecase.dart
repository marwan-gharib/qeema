import 'package:qeema/features/settings/domain/repositories/account_repository.dart';

/// Reads the live account type so the UI can show the right confirmation
/// dialog (deletion warning for guests only).
///
/// A synchronous session query, not an async operation: there is no failure
/// mode to wrap, so `call()` returns the bare bool instead of an `ApiResult`.
class IsCurrentUserAnonymousUseCase {
  const IsCurrentUserAnonymousUseCase(this._repository);
  final AccountRepository _repository;

  /// True when the signed-in user is an anonymous (guest) account.
  // TODO(dom4): DOM-4 asks for ApiResult returns; keeping the synchronous
  // bool is deliberate — an async conversion would delay the logout dialog
  // by an event-loop turn (behavior change, out of refactor scope).
  bool call() => _repository.isCurrentUserAnonymous();
}
