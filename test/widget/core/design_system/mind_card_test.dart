import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/design_system/cards/mind_card.dart';
import 'package:minduc/core/theme/mind_colors.dart';
import 'package:minduc/core/theme/mind_radii.dart';
import 'package:minduc/core/theme/mind_theme.dart';

void main() {
  Widget createWidgetUnderTest(Widget child) {
    return MaterialApp(
      theme: MindTheme.lightTheme,
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('MindCard Widget Tests', () {
    testWidgets('renders children and applies 22dp radius and background color', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          const MindCard(
            backgroundColor: MindColors.autocuidado,
            child: Text('Respiración'),
          ),
        ),
      );

      expect(find.text('Respiración'), findsOneWidget);

      final containerFinder = find.byType(Container).first;
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration?;

      expect(decoration, isNotNull);
      expect(decoration?.color, equals(MindColors.autocuidado));
      expect(decoration?.borderRadius, equals(MindRadii.cardRadius));
    });

    testWidgets('triggers onTap when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          MindCard(
            onTap: () => tapped = true,
            child: const Text('Toca aquí'),
          ),
        ),
      );

      await tester.tap(find.text('Toca aquí'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}

