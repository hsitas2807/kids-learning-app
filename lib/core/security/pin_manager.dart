import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../constants/app_constants.dart';

class PinManager {
  PinManager._();

  static String hashPin(String pin) {
    final saltedPin = 'kids_learning_app_salt_v1_$pin';
    final bytes = utf8.encode(saltedPin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static bool isValidPinFormat(String pin) {
    if (pin.length != AppConstants.pinLength) {
      return false;
    }
    return RegExp(r'^\d+$').hasMatch(pin);
  }

  static bool verifyPin(String plainPin, String storedHash) {
    if (!isValidPinFormat(plainPin)) {
      return false;
    }
    return hashPin(plainPin) == storedHash;
  }
}
