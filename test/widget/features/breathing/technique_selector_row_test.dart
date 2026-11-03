import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/breathing/domain/entities/breathing_technique.dart';
import 'package:minduc/features/breathing/presentation/widgets/technique_selector_row.dart';

void main() {
  group('TechniqueSelectorRow Widget Tests', () {
    testWidgets('renders technique name and cycle count pill', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TechniqueSelectorRow(
              currentTechnique: BreathingTechnique.box444,
              currentCycle: 6,
              totalCycles: 12,
              onTechniqueChanged: (_) {},
            ),
          ),
        ),
      );

      // Verify technique name is visible
      expect(find.text('Respiración 4-4-4 (Caja)'), findsOneWidget);
      // Verify cycle indicator is visible
      expect(find.text('Ciclo 6 de 12'), findsOneWidget);
    });

    testWidgets('tapping technique pill opens modal and selecting triggers callback', (tester) async {
      BreathingTechnique? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TechniqueSelectorRow(
              currentTechnique: BreathingTechnique.box444,
              currentCycle: 1,
              totalCycles: 10,
              onTechniqueChanged: (t) => selected = t,
            ),
          ),
        ),
      );

      // Tap on technique pill
      await tester.tap(find.text('Respiración 4-4-4 (Caja)'));
      await tester.pumpAndSettle();

      // Verify modal bottom sheet options appear
      expect(find.text('Respiración 4-7-8 (Relajante)'), findsOneWidget);
      expect(find.text('Respiración Serena 8-7'), findsOneWidget);

      // Select 4-7-8
      await tester.tap(find.text('Respiración 4-7-8 (Relajante)'));
      await tester.pumpAndSettle();

      expect(selected, BreathingTechnique.relaxing478);
    });

    testWidgets('renders Free mode cycle text when totalCycles is 0', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TechniqueSelectorRow(
              currentTechnique: BreathingTechnique.serene87,
              currentCycle: 3,
              totalCycles: 0,
              onTechniqueChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Ciclo 3'), findsOneWidget);
    });
  });
}
