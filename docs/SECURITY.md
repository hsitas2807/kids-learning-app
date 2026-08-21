# Security

## Parent PIN Protection

- PINs are never stored in plaintext
- SHA-256 hashing with application-specific salt
- Stored in platform secure storage (Keychain/Keystore)
- Maximum 5 attempts before lockout messaging

## Data Storage

- SharedPreferences for local learning data and app state
- Flutter Secure Storage for PIN hash and onboarding status
- No cloud transmission of personal data

## Privacy

- No advertising SDKs
- No analytics without consent
- No child email or phone required
- COPPA-compliant design
