import '../constants/app_constants.dart';

class Validators {
  Validators._();

  static String? validateChildName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a nickname';
    }
    if (value.trim().length < 2) {
      return 'Nickname must be at least 2 characters';
    }
    if (value.trim().length > 30) {
      return 'Nickname must be 30 characters or less';
    }
    if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(value.trim())) {
      return 'Please use only letters';
    }
    return null;
  }

  static String? validatePin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a PIN';
    }
    if (value.length != AppConstants.pinLength) {
      return 'PIN must be exactly 4 digits';
    }
    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      return 'PIN must contain only numbers';
    }
    return null;
  }

  static String? validateAge(int? age) {
    if (age == null) {
      return 'Please select an age';
    }
    if (age < 3 || age > 8) {
      return 'Age must be between 3 and 8';
    }
    return null;
  }
}
