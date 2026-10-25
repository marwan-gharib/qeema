import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Phase 5 (replaceability) enforcement: the scaling package may exist in
/// exactly one file, and its value-extension API must never leak anywhere.
void main() {
  final libFiles = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  final adapterPath = 'screen_util_scaler.dart';

  test('flutter_screenutil is imported by the adapter file only', () {
    final importers = [
      for (final file in libFiles)
        if (file.readAsStringSync().contains('package:flutter_screenutil'))
          file.path,
    ];

    expect(importers, hasLength(1));
    expect(importers.single, contains(adapterPath));
  });

  test('no screenutil value extension (.w/.h/.r/.sp/.sw/.sh) is used', () {
    final numberExtension = RegExp(r'\b\d+(?:\.\d+)?\.(?:w|h|r|sp|sw|sh)\b');

    final offenders = [
      for (final file in libFiles)
        if (numberExtension.hasMatch(file.readAsStringSync())) file.path,
    ];

    expect(offenders, isEmpty);
  });

  test('the ScreenUtil type is never referenced outside the adapter', () {
    final offenders = [
      for (final file in libFiles)
        if (!file.path.endsWith(adapterPath) &&
            file.readAsStringSync().contains('ScreenUtil'))
          file.path,
    ];

    expect(offenders, isEmpty);
  });
}
