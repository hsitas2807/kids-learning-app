import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/parent_dashboard/presentation/pages/parent_dashboard_page.dart';
import '../../features/parent_dashboard/presentation/pages/pin_entry_page.dart';
import '../../features/progress/presentation/pages/progress_page.dart';
import '../../features/rewards/presentation/pages/rewards_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.pinEntry,
        name: 'pin-entry',
        builder: (context, state) => const PinEntryPage(),
      ),
      GoRoute(
        path: AppRoutes.parentDashboard,
        name: 'parent-dashboard',
        builder: (context, state) => const ParentDashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.rewards,
        name: 'rewards',
        builder: (context, state) => const RewardsPage(),
      ),
      GoRoute(
        path: AppRoutes.progress,
        name: 'progress',
        builder: (context, state) => const ProgressPage(),
      ),
      GoRoute(
        path: AppRoutes.learning,
        name: 'learning',
        builder: (context, state) => const ComingSoonPage(feature: 'Learning'),
      ),
      GoRoute(
        path: AppRoutes.games,
        name: 'games',
        builder: (context, state) => const ComingSoonPage(feature: 'Games'),
      ),
      GoRoute(
        path: AppRoutes.stories,
        name: 'stories',
        builder: (context, state) => const ComingSoonPage(feature: 'Stories'),
      ),
      GoRoute(
        path: AppRoutes.drawing,
        name: 'drawing',
        builder: (context, state) => const ComingSoonPage(feature: 'Drawing'),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
});

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String pinEntry = '/pin-entry';
  static const String parentDashboard = '/parent-dashboard';
  static const String rewards = '/rewards';
  static const String progress = '/progress';
  static const String learning = '/learning';
  static const String games = '/games';
  static const String stories = '/stories';
  static const String drawing = '/drawing';
  static const String settings = '/settings';
}

class ComingSoonPage extends StatelessWidget {
  final String feature;

  const ComingSoonPage({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(feature)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 80, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              '$feature Coming Soon!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'This feature is under development.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 80),
            const SizedBox(height: 16),
            const Text('Oops! Page not found.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
