import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/exceptions.dart';
import 'package:qeema/features/assets/data/models/row_parsing.dart';

void main() {
  group('malformed', () {
    test('throws a ServerException naming the offending key', () {
      expect(
        () => malformed('price', true),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            contains('price'),
          ),
        ),
      );
    });
  });

  group('requiredString', () {
    test('returns the value when it is a String', () {
      expect(requiredString({'k': 'v'}, 'k'), 'v');
    });

    test('throws when the value is not a String', () {
      expect(
        () => requiredString({'k': 1}, 'k'),
        throwsA(isA<ServerException>()),
      );
    });

    test('throws when the key is absent', () {
      expect(() => requiredString({}, 'k'), throwsA(isA<ServerException>()));
    });
  });

  group('optionalString', () {
    test('accepts an absent key as null', () {
      expect(optionalString({}, 'k'), isNull);
    });

    test('returns the value when it is a String', () {
      expect(optionalString({'k': 'v'}, 'k'), 'v');
    });

    test('throws when a present value is not a String', () {
      expect(
        () => optionalString({'k': 1}, 'k'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('requiredNum', () {
    test('returns the value when it is a num', () {
      expect(requiredNum({'k': 2.5}, 'k'), 2.5);
    });

    test('throws when the value is not a num', () {
      expect(
        () => requiredNum({'k': '2.5'}, 'k'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('requiredBool', () {
    test('returns the value when it is a bool', () {
      expect(requiredBool({'k': true}, 'k'), isTrue);
    });

    test('throws when the value is not a bool', () {
      expect(
        () => requiredBool({'k': 1}, 'k'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('requiredDate', () {
    test('parses an ISO-8601 string', () {
      expect(requiredDate({'k': '2026-07-25'}, 'k'), DateTime(2026, 7, 25));
    });

    test('throws when the value is not a String', () {
      expect(
        () => requiredDate({'k': 1}, 'k'),
        throwsA(isA<ServerException>()),
      );
    });

    test('throws when the string is not parsable as a date', () {
      expect(
        () => requiredDate({'k': 'whenever'}, 'k'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('optionalMap', () {
    test('accepts an absent key as null', () {
      expect(optionalMap({}, 'k'), isNull);
    });

    test('returns the value when it is a Map', () {
      expect(
        optionalMap({
          'k': {'a': 1},
        }, 'k'),
        {'a': 1},
      );
    });

    test('throws when a present value is not a Map', () {
      expect(() => optionalMap({'k': 1}, 'k'), throwsA(isA<ServerException>()));
    });
  });
}
