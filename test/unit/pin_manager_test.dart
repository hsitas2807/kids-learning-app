import 'package:flutter_test/flutter_test.dart';
import 'package:kids_learning_app/core/security/pin_manager.dart';

void main() {
  const testSalt = 'test_device_salt_abc123';

  group('PinManager', () {
    test('hashPin returns consistent hash for same PIN and salt', () {
      final hash1 = PinManager.hashPin('1234', testSalt);
      final hash2 = PinManager.hashPin('1234', testSalt);
      expect(hash1, equals(hash2));
    });

    test('hashPin returns different hash for different PINs', () {
      final hash1 = PinManager.hashPin('1234', testSalt);
      final hash2 = PinManager.hashPin('5678', testSalt);
      expect(hash1, isNot(equals(hash2)));
    });

    test('hashPin returns different hash for different salts', () {
      final hash1 = PinManager.hashPin('1234', 'salt_one');
      final hash2 = PinManager.hashPin('1234', 'salt_two');
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
      final hash = PinManager.hashPin(pin, testSalt);
      expect(PinManager.verifyPin(pin, hash, testSalt), isTrue);
    });

    test('verifyPin returns false for incorrect PIN', () {
      const pin = '1234';
      final hash = PinManager.hashPin(pin, testSalt);
      expect(PinManager.verifyPin('9999', hash, testSalt), isFalse);
    });

    test('verifyPin returns false for wrong salt', () {
      const pin = '1234';
      final hash = PinManager.hashPin(pin, testSalt);
      expect(PinManager.verifyPin(pin, hash, 'wrong_salt'), isFalse);
    });

    test('verifyPin returns false for invalid format', () {
      final hash = PinManager.hashPin('1234', testSalt);
      expect(PinManager.verifyPin('abc', hash, testSalt), isFalse);
    });
  });
}
