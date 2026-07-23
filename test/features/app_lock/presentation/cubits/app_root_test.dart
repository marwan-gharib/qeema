import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/app_root.dart';

void main() {
  group('resolveColdStartDecision', () {
    test('no session returns proceed', () async {
      final result = await resolveColdStartDecision(
        hasSession: false,
        isEnabled: Future.value(true),
        isDeviceSupported: Future.value(true),
      );
      expect(result, ColdStartDecision.proceed);
    });

    test('session + disabled returns proceed', () async {
      final result = await resolveColdStartDecision(
        hasSession: true,
        isEnabled: Future.value(false),
        isDeviceSupported: Future.value(true),
      );
      expect(result, ColdStartDecision.proceed);
    });

    test('session + enabled + unsupported returns proceed', () async {
      final result = await resolveColdStartDecision(
        hasSession: true,
        isEnabled: Future.value(true),
        isDeviceSupported: Future.value(false),
      );
      expect(result, ColdStartDecision.proceed);
    });

    test('session + enabled + supported returns requireUnlock', () async {
      final result = await resolveColdStartDecision(
        hasSession: true,
        isEnabled: Future.value(true),
        isDeviceSupported: Future.value(true),
      );
      expect(result, ColdStartDecision.requireUnlock);
    });
  });
}
