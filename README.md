# Kids Learning App 📚

An offline-first educational app for children aged 3–8 years, built with Flutter.

## Features

- 🌐 **Works offline** — No internet required for core learning
- 🎓 **Three learning levels** — Ages 3–4, 5–6, 7–8
- 🎮 **Games & Activities** — Interactive learning through play
- 📖 **Stories** — Age-appropriate stories
- 🎨 **Drawing** — Creative expression
- 🏆 **Rewards System** — Stars, coins, badges, streaks
- 🔒 **Parent Dashboard** — PIN-protected parent controls
- ♿ **Accessible** — Screen reader support, large touch targets
- 🔐 **Privacy-first** — No accounts, no ads, no tracking

## Tech Stack

- **Flutter** (Dart 3.0+)
- **Riverpod** — State management
- **GoRouter** — Navigation
- **SharedPreferences** — Offline local storage
- **Flutter Secure Storage** — Secure PIN storage
- **Google Fonts** — Fredoka (child UI), Roboto (parent UI)

## Architecture

Clean Architecture: Presentation → Domain → Data → Local Storage

## Getting Started

```bash
flutter pub get
flutter run
```

## Documentation

- [Architecture](docs/ARCHITECTURE.md)
- [Database Schema](docs/DATABASE_SCHEMA.md)
- [Security](docs/SECURITY.md)

## License

MIT
