import 'package:local_auth/local_auth.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';

class BiometricAuthService {
  BiometricAuthService(this._localAuth);
  final LocalAuthentication _localAuth;

  Future<ApiResult<bool>> authenticate({
    required String localizedReason,
  }) async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: localizedReason,
      );
      return Success(authenticated);
    } catch (e) {
      return const ResultFailure(AuthFailure(null));
    }
  }

  Future<bool> get isAvailable async {
    try {
      return await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }
}
