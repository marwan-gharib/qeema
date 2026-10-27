import 'package:qeema/core/error/exceptions.dart';

/// A server row is missing a required key or holds an unexpected type.
///
/// Thrown by the defensive readers below so the repository's catch maps it to
/// a `Failure` (DATA-3) with the offending key in `debugDetail`, instead of a
/// raw `TypeError`/`FormatException` with no context.
Never malformed(String key, Object? value) => throw ServerException(
  'Malformed server row: "$key" was ${value.runtimeType}',
  'parse',
);

String requiredString(Map<String, dynamic> row, String key) {
  final value = row[key];
  return value is String ? value : malformed(key, value);
}

/// Accepts an absent key as null; a present but non-String value is malformed.
String? optionalString(Map<String, dynamic> row, String key) {
  final value = row[key];
  if (value == null) return null;
  return value is String ? value : malformed(key, value);
}

num requiredNum(Map<String, dynamic> row, String key) {
  final value = row[key];
  return value is num ? value : malformed(key, value);
}

bool requiredBool(Map<String, dynamic> row, String key) {
  final value = row[key];
  return value is bool ? value : malformed(key, value);
}

DateTime requiredDate(Map<String, dynamic> row, String key) {
  final value = row[key];
  if (value is! String) return malformed(key, value);
  return DateTime.tryParse(value) ?? malformed(key, value);
}

/// Accepts an absent key as null; a present but non-map value is malformed.
Map<String, dynamic>? optionalMap(Map<String, dynamic> row, String key) {
  final value = row[key];
  if (value == null) return null;
  return value is Map<String, dynamic> ? value : malformed(key, value);
}
