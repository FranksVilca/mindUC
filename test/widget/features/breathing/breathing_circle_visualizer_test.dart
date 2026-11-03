import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/breathing/domain/entities/breathing_phase.dart';
import 'package:minduc/features/breathing/presentation/widgets/breathing_circle_visualizer.dart';

void main() {
  group('BreathingCircleVisualizer Widget Tests', () {
    testWidgets('renders inhale phase instructions, countdown and biomechanical hint', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BreathingCircleVisualizer(
              phase: BreathingPhase.inhale,
              secondsRemaining: 4,
              phaseProgressFraction: 0.25,
              isRunning: true,
            ),
          ),
        ),
      );

      // Verify instruction text
      expect(find.text('Inhala suave'), findsOneWidget);
      // Verify countdown text
      expect(find.text('4s'), findsOneWidget);
      // Verify biomechanical hint
      expect(find.text('EXPANDE EL ABDOMEN'), findsOneWidget);
      // Verify wind/air icon
      expect(find.byIcon(Icons.air), findsOneWidget);
    });

    testWidgets('renders hold phase instruction and biomechanical hint correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BreathingCircleVisualizer(
              phase: BreathingPhase.hold,
              secondsRemaining: 7,
              phaseProgressFraction: 0.5,
              isRunning: true,
            ),
          ),
        ),
      );

      expect(find.text('Retén el aire'), findsOneWidget);
      expect(find.text('7s'), findsOneWidget);
      expect(find.text('MANTÉN LA CALMA'), findsOneWidget);
    });

    testWidgets('renders exhale phase instruction and biomechanical hint correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BreathingCircleVisualizer(
              phase: BreathingPhase.exhale,
              secondsRemaining: 2,
              phaseProgressFraction: 0.75,
              isRunning: false,
            ),
          ),
        ),
      );

      expect(find.text('Exhala despacio'), findsOneWidget);
      expect(find.text('2s'), findsOneWidget);
      expect(find.text('LIBERA LA TENSIÓN'), findsOneWidget);
    });
  });
}
