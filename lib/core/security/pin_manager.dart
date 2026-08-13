import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../constants/app_constants.dart';

class PinManager {
  PinManager._();

  /// Hash a PIN using SHA-256 with a per-device salt.
  /// [salt] must be retrieved from [SecureStorageService.getOrCreatePinSalt].
  static String hashPin(String pin, String salt) {
    final saltedPin = '${salt}_$pin';
    final bytes = utf8.encode(saltedPin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Validate a PIN format: must be exactly [AppConstants.pinLength] digits.
  static bool isValidPinFormat(String pin) {
    if (pin.length != AppConstants.pinLength) {
      return false;
    }
    return RegExp(r'^\d+$').hasMatch(pin);
  }

  /// Verify a plain PIN against a stored hash using the device salt.
  static bool verifyPin(String plainPin, String storedHash, String salt) {
    if (!isValidPinFormat(plainPin)) {
      return false;
    }
    return hashPin(plainPin, salt) == storedHash;
  }
}
