import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/security/pin_manager.dart';
import '../../../../core/security/secure_storage_service.dart';
import '../../../../core/theme/app_theme.dart';

class PinEntryPage extends StatefulWidget {
  const PinEntryPage({super.key});

  @override
  State<PinEntryPage> createState() => _PinEntryPageState();
}

class _PinEntryPageState extends State<PinEntryPage> {
  final SecureStorageService _storage = SecureStorageService();
  String _enteredPin = '';
  String? _storedHash;
  String? _deviceSalt;
  bool _isSettingUp = false;
  String? _tempPin;
  String? _errorMessage;
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    _checkForExistingPin();
  }

  Future<void> _checkForExistingPin() async {
    final hash = await _storage.getParentPinHash();
    final salt = await _storage.getOrCreatePinSalt();
    final lockUntil = await _storage.getPinLockUntil();
    final locked = lockUntil != null && lockUntil.isAfter(DateTime.now());
    if (!mounted) return;
    setState(() {
      _storedHash = hash;
      _deviceSalt = salt;
      _isSettingUp = hash == null;
      _isLocked = locked;
      if (locked && lockUntil != null) {
        final remaining = lockUntil.difference(DateTime.now()).inMinutes + 1;
        _errorMessage = 'Too many attempts. Try again in $remaining minute(s).';
      }
    });
  }

  void _onKeyTap(String key) {
    if (_isLocked || _enteredPin.length >= AppConstants.pinLength) return;
    setState(() {
      _enteredPin += key;
      _errorMessage = null;
    });
    if (_enteredPin.length == AppConstants.pinLength) {
      Future<void>.delayed(const Duration(milliseconds: 150), _processPin);
    }
  }

  void _onDelete() {
    if (_enteredPin.isEmpty) return;
    setState(() {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      _errorMessage = null;
    });
  }

  Future<void> _processPin() async {
    final salt = _deviceSalt;
    if (salt == null) return;

    if (_isSettingUp) {
      if (_tempPin == null) {
        setState(() {
          _tempPin = _enteredPin;
          _enteredPin = '';
        });
      } else {
        if (_enteredPin == _tempPin) {
          final hash = PinManager.hashPin(_enteredPin, salt);
          await _storage.saveParentPinHash(hash);
          await _storage.resetPinAttempts();
          if (mounted) context.go(AppRoutes.parentDashboard);
        } else {
          setState(() {
            _errorMessage = 'PINs do not match. Try again.';
            _enteredPin = '';
            _tempPin = null;
          });
        }
      }
    } else {
      if (_storedHash != null &&
          PinManager.verifyPin(_enteredPin, _storedHash!, salt)) {
        await _storage.resetPinAttempts();
        if (mounted) context.go(AppRoutes.parentDashboard);
      } else {
        final attempts = await _storage.getPinAttempts() + 1;
        await _storage.savePinAttempts(attempts);
        if (attempts >= AppConstants.maxPinAttempts) {
          final lockUntil = DateTime.now().add(const Duration(minutes: 5));
          await _storage.savePinLockUntil(lockUntil);
          setState(() {
            _isLocked = true;
            _errorMessage = 'Too many attempts. Try again in 5 minute(s).';
            _enteredPin = '';
          });
        } else {
          final remaining = AppConstants.maxPinAttempts - attempts;
          setState(() {
            _errorMessage = 'Incorrect PIN. $remaining attempt(s) remaining.';
            _enteredPin = '';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.parentTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Parent Mode'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go(AppRoutes.home),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacing32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 64, color: Color(0xFF1565C0)),
                const SizedBox(height: AppConstants.spacing24),
                Text(
                  _isSettingUp
                      ? (_tempPin == null
                          ? 'Create a 4-digit PIN'
                          : 'Confirm your PIN')
                      : 'Enter Parent PIN',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacing32),
                _buildPinDots(),
                if (_errorMessage != null) ...<Widget>[
                  const SizedBox(height: AppConstants.spacing16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: AppConstants.spacing32),
                _buildKeypad(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(AppConstants.pinLength, (int i) {
        return Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i < _enteredPin.length
                ? const Color(0xFF1565C0)
                : const Color(0xFFE0E0E0),
          ),
        );
      }),
    );
  }

  Widget _buildKeypad() {
    const keys = <List<String>>[
      <String>['1', '2', '3'],
      <String>['4', '5', '6'],
      <String>['7', '8', '9'],
      <String>['', '0', 'del'],
    ];

    return Column(
      children: keys.map((List<String> row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((String key) {
            if (key.isEmpty) {
              return const SizedBox(width: 80, height: 72);
            }
            return Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: 72,
                height: 72,
                child: key == 'del'
                    ? IconButton(
                        onPressed: _onDelete,
                        icon: const Icon(Icons.backspace_outlined),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          shape: const CircleBorder(),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _isLocked ? null : () => _onKeyTap(key),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.grey.shade100,
                          foregroundColor: Colors.black87,
                          elevation: 2,
                        ),
                        child: Text(
                          key,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
