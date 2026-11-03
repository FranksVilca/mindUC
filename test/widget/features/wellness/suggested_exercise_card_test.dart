import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/wellness/domain/entities/wellness_suggested_exercise.dart';
import 'package:minduc/features/wellness/presentation/widgets/sanctuary_badge.dart';
import 'package:minduc/features/wellness/presentation/widgets/suggested_exercise_card.dart';

void main() {
  group('SuggestedExerciseCard & SanctuaryBadge Widget Tests', () {
    testWidgets('SanctuaryBadge renders label and plant icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SanctuaryBadge(),
          ),
        ),
      );

      expect(find.text('SANCTUARY MODE'), findsOneWidget);
      expect(find.byIcon(Icons.spa), findsOneWidget);
    });

    testWidgets('SuggestedExerciseCard renders all details and triggers onStart callback', (tester) async {
      bool startCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SuggestedExerciseCard(
              exercise: WellnessSuggestedExercise.defaultDaily,
              onStart: () => startCalled = true,
            ),
          ),
        ),
      );

      // Verify category kicker
      expect(find.text('EJERCICIO SUGERIDO PARA TI HOY'), findsOneWidget);
      // Verify exercise title
      expect(find.text('Respiración 4–7–8'), findsOneWidget);
      // Verify description
      expect(find.text('Técnica antiestrés recomendada para despejar la sobrecarga'), findsOneWidget);
      // Verify air icon
      expect(find.byIcon(Icons.air), findsOneWidget);
      // Verify cycle label
      expect(find.text('Ciclo guiado'), findsOneWidget);
      // Verify action button
      expect(find.text('Comenzar (5 min)'), findsOneWidget);

      // Tap on button
      await tester.tap(find.text('Comenzar (5 min)'));
      await tester.pump();

      expect(startCalled, isTrue);
    });
  });
}
