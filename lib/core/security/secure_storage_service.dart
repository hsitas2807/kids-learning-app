import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const String _parentPinHashKey = 'parent_pin_hash';
  static const String _pinSaltKey = 'parent_pin_salt';
  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _pinAttemptsKey = 'pin_attempts';
  static const String _pinLockUntilKey = 'pin_lock_until';

  /// Generate and persist a per-device random salt for PIN hashing.
  Future<String> getOrCreatePinSalt() async {
    final existing = await _storage.read(key: _pinSaltKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final salt = _generateRandomSalt();
    await _storage.write(key: _pinSaltKey, value: salt);
    return salt;
  }

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

  // PIN attempt tracking (persisted across sessions)

  Future<int> getPinAttempts() async {
    final value = await _storage.read(key: _pinAttemptsKey);
    return int.tryParse(value ?? '0') ?? 0;
  }

  Future<void> savePinAttempts(int attempts) async {
    await _storage.write(key: _pinAttemptsKey, value: attempts.toString());
  }

  Future<void> resetPinAttempts() async {
    await _storage.delete(key: _pinAttemptsKey);
    await _storage.delete(key: _pinLockUntilKey);
  }

  Future<DateTime?> getPinLockUntil() async {
    final value = await _storage.read(key: _pinLockUntilKey);
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  Future<void> savePinLockUntil(DateTime until) async {
    await _storage.write(key: _pinLockUntilKey, value: until.toIso8601String());
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  static String _generateRandomSalt() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rng = Random.secure();
    return List.generate(32, (_) => chars[rng.nextInt(chars.length)]).join();
  }
}
