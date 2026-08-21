# kids-learning-app Progress Notes

Source branch: `copilot/setup-project-architecture`

## Current status
- The repository work on this branch is **done** from a code-completion perspective.
- The pull request is still **open** and **draft**, so it is not merged yet.
- The branch is associated with **PR #1**: `feat: Phase 1 — offline-first Kids Learning Flutter app (foundation + architecture)`.

## What was implemented

### Architecture
- Clean architecture: Presentation → Domain → Data → Local Storage
- Riverpod for state management
- GoRouter for navigation
- SharedPreferences for local persistence
- FlutterSecureStorage for secure data

### Core app screens
- Splash screen with animation and auto-routing
- Parent onboarding flow
- Child home screen with large touch targets
- PIN entry screen for setup and verification
- Parent dashboard
- Rewards page
- Progress page with real data and empty states

### Security hardening
- Per-device random salt for PIN hashing
- SHA-256 hashing of `salt + PIN`
- Persisted PIN attempt counter
- 5-minute lockout after 5 failed attempts
- Lockout survives navigation and restart

### Testing
- Unit tests for PIN manager and validation logic
- Widget tests for key UI components

### CI/CD
- GitHub Actions workflow for analyze, test, and Android APK build
- Least-privilege workflow permissions added (`contents: read`)

### Documentation
- Architecture documentation
- Database schema documentation
- Security documentation

## Important notes
- The branch was updated after review to fix a duplicate section in `pin_entry_page.dart`.
- The CI workflow was also updated to satisfy GitHub Actions permission best practices.
- The agent logs explicitly stated: **“All work is complete.”**

## Reminders
- Merge the draft PR when ready.
- Run the full CI workflow after any further changes.
- Keep this file updated if the branch changes again.
