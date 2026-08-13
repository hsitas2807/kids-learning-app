import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_learning_app/features/home/presentation/widgets/home_nav_button.dart';

void main() {
  group('HomeNavButton', () {
    testWidgets('renders icon and label', (WidgetTester tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeNavButton(
              icon: '📚',
              label: 'Learn',
              color: Colors.purple,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );
      expect(find.text('📚'), findsOneWidget);
      expect(find.text('Learn'), findsOneWidget);
      expect(tapped, isFalse);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeNavButton(
              icon: '🎮',
              label: 'Games',
              color: Colors.red,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(HomeNavButton));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('has semantic label for accessibility', (
      WidgetTester tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeNavButton(
              icon: '📖',
              label: 'Stories',
              color: Colors.green,
              onTap: () {},
            ),
          ),
        ),
      );
      expect(
        tester.getSemantics(find.byType(HomeNavButton)),
        matchesSemantics(label: 'Stories', isButton: true),
      );
      semantics.dispose();
    });
  });
}
