import 'package:flutter/services.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';

class WindowSecurityService {
  WindowSecurityService({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel(channelName);

  static const channelName = 'qeema/window_security';
  static const setRecentsPreviewHiddenMethod = 'setRecentsPreviewHidden';

  final MethodChannel _channel;

  /// Platform exceptions are swallowed: failing to hide a preview must never
  /// block the lock flow. `MethodChannel` can only raise these two, so there is
  /// no untestable third branch to map.
  Future<ApiResult<void>> setRecentsPreviewHidden({
    required bool hidden,
  }) async {
    try {
      await _channel.invokeMethod<void>(
        setRecentsPreviewHiddenMethod,
        <String, Object>{'hidden': hidden},
      );
      return const Success(null);
    } on MissingPluginException {
      // Return a failure so the caller knows the platform lacks the handler,
      // without throwing an exception that could block the flow.
      return const ResultFailure(UnknownFailure());
    } on PlatformException {
      return const ResultFailure(UnknownFailure());
    }
  }
}
