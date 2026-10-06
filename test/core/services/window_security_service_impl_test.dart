import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/extensions/api_result_extensions.dart';
import 'package:qeema/core/services/window_security_service.dart';
import 'package:qeema/core/utils/api_result.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<MethodCall> calls;
  late WindowSecurityService service;

  setUp(() {
    calls = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel(WindowSecurityService.channelName),
          (call) async {
            calls.add(call);
            return null;
          },
        );
    service = WindowSecurityService();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel(WindowSecurityService.channelName),
          null,
        );
  });

  test(
    'invokes the channel name and method the native sides implement',
    () async {
      final result = await service.setRecentsPreviewHidden(hidden: true);

      expect(result, isA<Success<void>>());
      expect(calls, hasLength(1));
      expect(calls.single.method, 'setRecentsPreviewHidden');
      expect(calls.single.arguments, <String, Object>{'hidden': true});
    },
  );

  test('passes the unhidden flag through unchanged', () async {
    await service.setRecentsPreviewHidden(hidden: false);

    expect(calls.single.arguments, <String, Object>{'hidden': false});
  });

  test('reports failure when the platform has no native handler', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel(WindowSecurityService.channelName),
          null,
        );

    final result = await service.setRecentsPreviewHidden(hidden: true);

    expect(result.failureOrNull, isNotNull);
  });

  test('reports failure when the platform throws', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel(WindowSecurityService.channelName),
          (call) async => throw PlatformException(code: 'boom'),
        );

    final result = await service.setRecentsPreviewHidden(hidden: true);

    expect(result.failureOrNull, isNotNull);
  });
}
