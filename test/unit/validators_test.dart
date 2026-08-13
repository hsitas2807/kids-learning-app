import 'package:flutter_test/flutter_test.dart';
import 'package:kids_learning_app/core/utilities/validators.dart';

void main() {
  group('Validators.validateChildName', () {
    test('returns null for valid name', () {
      expect(Validators.validateChildName('Alice'), isNull);
      expect(Validators.validateChildName('Bob'), isNull);
    });

    test('returns error for empty name', () {
      expect(Validators.validateChildName(''), isNotNull);
      expect(Validators.validateChildName(null), isNotNull);
    });

    test('returns error for too short name', () {
      expect(Validators.validateChildName('A'), isNotNull);
    });

    test('returns error for too long name', () {
      expect(Validators.validateChildName('A' * 31), isNotNull);
    });

    test('returns error for invalid characters', () {
      expect(Validators.validateChildName('Alice123'), isNotNull);
      expect(Validators.validateChildName('Alice@'), isNotNull);
    });
  });

  group('Validators.validatePin', () {
    test('returns null for valid 4-digit PIN', () {
      expect(Validators.validatePin('1234'), isNull);
    });

    test('returns error for wrong length', () {
      expect(Validators.validatePin('123'), isNotNull);
      expect(Validators.validatePin('12345'), isNotNull);
    });

    test('returns error for non-numeric PIN', () {
      expect(Validators.validatePin('abcd'), isNotNull);
    });
  });

  group('Validators.validateAge', () {
    test('returns null for valid ages 3-8', () {
      for (var age = 3; age <= 8; age++) {
        expect(Validators.validateAge(age), isNull);
      }
    });

    test('returns error for out-of-range ages', () {
      expect(Validators.validateAge(2), isNotNull);
      expect(Validators.validateAge(9), isNotNull);
      expect(Validators.validateAge(null), isNotNull);
    });
  });
}
