# Architecture

## Overview

Kids Learning App follows Clean Architecture principles.

```text
Presentation Layer (Flutter Widgets)
         ↓
    Domain Layer (Business Logic)
         ↓
     Data Layer (Repositories)
         ↓
  Local Storage (SharedPreferences)
```

## State Management

Riverpod is used for dependency injection and state management.

## Navigation

GoRouter provides type-safe, declarative navigation.

## Storage

SharedPreferences stores onboarding, child profile, rewards, and progress data locally for offline-first usage. No network connection is required for the core app experience.

## Security

- Parent PIN hashed with SHA-256
- Sensitive data in Flutter Secure Storage
- No child PII collected beyond local nickname data
