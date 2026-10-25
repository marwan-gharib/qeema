import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the app's one UI exception — charts never mirror with the locale.
///
/// If any of these fail, a chart has either escaped the shared wrapper, or the
/// wrapper has stopped being the only place that decides chart direction.
void main() {
  const wrapperPath = 'lib/core/widgets/app_chart_directionality.dart';
  const policyPath = 'lib/core/constants/chart_constants.dart';
  const policyReaders = {wrapperPath, policyPath};

  late List<File> libFiles;

  setUpAll(() {
    libFiles =
        Directory('lib')
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    expect(libFiles, isNotEmpty, reason: 'lib/ was not scanned');
  });

  String pathOf(File file) => file.path.replaceAll(r'\', '/');

  test('every chart widget goes through the shared wrapper', () {
    final offenders = <String>[];
    for (final file in libFiles) {
      final source = file.readAsStringSync();
      if (!source.contains('package:fl_chart/')) continue;
      if (!source.contains(
        'package:qeema/core/widgets/app_chart_directionality.dart',
      )) {
        offenders.add(pathOf(file));
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'These build an fl_chart chart without AppChartDirectionality: '
          '$offenders',
    );
  });

  test('only the shared wrapper pins a chart to TextDirection.ltr', () {
    final offenders = <String>[];
    for (final file in libFiles) {
      final path = pathOf(file);
      if (path == wrapperPath) continue;
      if (file.readAsStringSync().contains('TextDirection.ltr')) {
        offenders.add(path);
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'Charts must take their direction from appChartTextDirection, not a '
          'local TextDirection.ltr: $offenders',
    );
  });

  test('no chart file builds its own Directionality', () {
    final bareDirectionality = RegExp(r'(?<!\w)Directionality\s*\(');
    final offenders = <String>[];
    for (final file in libFiles) {
      final source = file.readAsStringSync();
      if (!source.contains('package:fl_chart/')) continue;
      if (bareDirectionality.hasMatch(source)) offenders.add(pathOf(file));
    }

    expect(
      offenders,
      isEmpty,
      reason: 'These wrap a chart in their own Directionality: $offenders',
    );
  });

  test('nothing outside the wrapper reads the chart policy switch', () {
    final offenders = <String>[];
    for (final file in libFiles) {
      final path = pathOf(file);
      if (policyReaders.contains(path)) continue;
      if (file.readAsStringSync().contains('alwaysChartsLtr')) {
        offenders.add(path);
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'Read ChartConstants.alwaysChartsLtr via appChartTextDirection: $offenders',
    );
  });
}
