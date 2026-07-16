import 'package:local_auth/local_auth.dart';

import '../error/failures.dart';
import '../utils/api_result.dart';

class BiometricAuthService {
  final LocalAuthentication _localAuth;

  BiometricAuthService(this._localAuth);

  Future<ApiResult<bool>> authenticate() async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Unlock Qeema to view your finances',
      );
      return Success(authenticated);
    } catch (e) {
      return ResultFailure(
        const AuthFailure('Biometric authentication failed'),
      );
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
