import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/settings/presentation/mappers/app_lock_prompt_mapper.dart';

void main() {
  group('AppLockPromptMapper.fromResult', () {
    test('maps a confirmed authentication to confirmed', () {
      final outcome = AppLockPromptMapper.fromResult(
        const Success(AppLockStatus.authenticated),
      );

      expect(outcome, AppLockPromptOutcome.confirmed);
    });

    test('maps a cancelled prompt to declined', () {
      final outcome = AppLockPromptMapper.fromResult(
        const Success(AppLockStatus.failed),
      );

      expect(outcome, AppLockPromptOutcome.declined);
    });

    test('maps a locked-out device to declined', () {
      final outcome = AppLockPromptMapper.fromResult(
        const Success(AppLockStatus.lockedOut),
      );

      expect(outcome, AppLockPromptOutcome.declined);
    });

    test('maps no device credentials to declined', () {
      final outcome = AppLockPromptMapper.fromResult(
        const Success(AppLockStatus.notRequired),
      );

      expect(outcome, AppLockPromptOutcome.declined);
    });

    test('maps a failure to declined', () {
      final outcome = AppLockPromptMapper.fromResult(
        const ResultFailure(LocalAuthUnknownFailure()),
      );

      expect(outcome, AppLockPromptOutcome.declined);
    });
  });
}
