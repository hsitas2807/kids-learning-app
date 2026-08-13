import 'package:flutter_test/flutter_test.dart';
import 'package:kids_learning_app/core/security/pin_manager.dart';

void main() {
  group('PinManager', () {
    test('hashPin returns consistent hash for same PIN', () {
      final hash1 = PinManager.hashPin('1234');
      final hash2 = PinManager.hashPin('1234');
      expect(hash1, equals(hash2));
    });

    test('hashPin returns different hash for different PINs', () {
      final hash1 = PinManager.hashPin('1234');
      final hash2 = PinManager.hashPin('5678');
      expect(hash1, isNot(equals(hash2)));
    });

    test('isValidPinFormat accepts valid 4-digit PIN', () {
      expect(PinManager.isValidPinFormat('1234'), isTrue);
      expect(PinManager.isValidPinFormat('0000'), isTrue);
      expect(PinManager.isValidPinFormat('9999'), isTrue);
    });

    test('isValidPinFormat rejects invalid PINs', () {
      expect(PinManager.isValidPinFormat('123'), isFalse);
      expect(PinManager.isValidPinFormat('12345'), isFalse);
      expect(PinManager.isValidPinFormat('abcd'), isFalse);
      expect(PinManager.isValidPinFormat(''), isFalse);
    });

    test('verifyPin returns true for correct PIN', () {
      const pin = '1234';
      final hash = PinManager.hashPin(pin);
      expect(PinManager.verifyPin(pin, hash), isTrue);
    });

    test('verifyPin returns false for incorrect PIN', () {
      const pin = '1234';
      final hash = PinManager.hashPin(pin);
      expect(PinManager.verifyPin('9999', hash), isFalse);
    });

    test('verifyPin returns false for invalid format', () {
      final hash = PinManager.hashPin('1234');
      expect(PinManager.verifyPin('abc', hash), isFalse);
    });
  });
}
