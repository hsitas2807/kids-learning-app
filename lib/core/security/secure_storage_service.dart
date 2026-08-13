import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const String _parentPinHashKey = 'parent_pin_hash';
  static const String _onboardingCompleteKey = 'onboarding_complete';

  Future<void> saveParentPinHash(String hash) async {
    await _storage.write(key: _parentPinHashKey, value: hash);
  }

  Future<String?> getParentPinHash() async {
    return _storage.read(key: _parentPinHashKey);
  }

  Future<void> setOnboardingComplete(bool complete) async {
    await _storage.write(
      key: _onboardingCompleteKey,
      value: complete.toString(),
    );
  }

  Future<bool> isOnboardingComplete() async {
    final value = await _storage.read(key: _onboardingCompleteKey);
    return value == 'true';
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
