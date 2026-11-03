import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/breathing/presentation/widgets/duration_presets_pill.dart';
import 'package:minduc/features/breathing/presentation/widgets/session_progress_card.dart';

void main() {
  group('SessionProgressCard & DurationPresetsPill Widget Tests', () {
    testWidgets('SessionProgressCard renders formatted time remaining and total', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SessionProgressCard(
              elapsedSeconds: 137, // 10:00 - 02:17 = 07:43 remaining
              targetSeconds: 600, // 10:00
              progressFraction: 0.228,
            ),
          ),
        ),
      );

      // Remaining: 600 - 137 = 463s = 07:43
      // Total: 600s = 10:00
      expect(find.text('07:43 / 10:00'), findsOneWidget);
      expect(find.text('Tiempo restante'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('SessionProgressCard handles Free mode correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SessionProgressCard(
              elapsedSeconds: 125, // 02:05
              targetSeconds: 0,
              progressFraction: 0.0,
            ),
          ),
        ),
      );

      expect(find.text('02:05'), findsOneWidget);
      expect(find.text('Tiempo transcurrido'), findsOneWidget);
    });

    testWidgets('DurationPresetsPill displays 4 options and triggers onPresetSelected', (tester) async {
      int? selectedSeconds;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DurationPresetsPill(
              currentTargetSeconds: 600,
              onPresetSelected: (sec) => selectedSeconds = sec,
            ),
          ),
        ),
      );

      expect(find.text('3 min'), findsOneWidget);
      expect(find.text('5 min'), findsOneWidget);
      expect(find.text('10 min'), findsOneWidget);
      expect(find.text('Libre'), findsOneWidget);

      // Tap 5 min (300 seconds)
      await tester.tap(find.text('5 min'));
      await tester.pump();

      expect(selectedSeconds, 300);

      // Tap Libre (0 seconds)
      await tester.tap(find.text('Libre'));
      await tester.pump();

      expect(selectedSeconds, 0);
    });
  });
}
