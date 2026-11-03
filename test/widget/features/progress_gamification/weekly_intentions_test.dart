import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/progress_gamification/domain/entities/weekly_intention.dart';
import 'package:minduc/features/progress_gamification/presentation/widgets/self_compassion_card.dart';
import 'package:minduc/features/progress_gamification/presentation/widgets/weekly_intentions_card.dart';

void main() {
  group('WeeklyIntentionsCard Widget Tests', () {
    testWidgets('renders header, heart icon, 3 intentions and triggers callback',
        (tester) async {
      String? toggledId;

      const intentions = [
        WeeklyIntention(
          id: 'int-1',
          title: 'Hacer 3 pausas activas antes del almuerzo',
          currentUnits: 3,
          targetUnits: 3,
          unitLabel: 'completadas hoy',
          isCompleted: true,
          iconType: IntentionIconType.pauses,
        ),
        WeeklyIntention(
          id: 'int-2',
          title: 'Tomar un paseo consciente de 10 min',
          currentUnits: 2,
          targetUnits: 3,
          unitLabel: 'días',
          isCompleted: false,
          iconType: IntentionIconType.walk,
        ),
        WeeklyIntention(
          id: 'int-3',
          title: 'Desconectar pantallas 30 min antes de dormir',
          currentUnits: 2,
          targetUnits: 4,
          unitLabel: 'noches',
          isCompleted: false,
          iconType: IntentionIconType.screens,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: WeeklyIntentionsCard(
                intentions: intentions,
                onToggleIntention: (id) => toggledId = id,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Intenciones de la semana'), findsOneWidget);
      expect(
        find.text('Metas sin prisa, enfocadas en sentirte bien'),
        findsOneWidget,
      );

      // Intención 1
      expect(
        find.text('Hacer 3 pausas activas antes del almuerzo'),
        findsOneWidget,
      );
      expect(find.text('3 de 3 completadas hoy'), findsOneWidget);

      // Intención 2
      expect(
        find.text('Tomar un paseo consciente de 10 min'),
        findsOneWidget,
      );
      expect(find.text('2 / 3 días'), findsOneWidget);

      // Intención 3
      expect(
        find.text('Desconectar pantallas 30 min antes de dormir'),
        findsOneWidget,
      );
      expect(find.text('2 / 4 noches'), findsOneWidget);

      // Tocar intención 2
      await tester.tap(find.text('Tomar un paseo consciente de 10 min'));
      await tester.pump();

      expect(toggledId, 'int-2');
    });
  });

  group('SelfCompassionCard Widget Tests', () {
    testWidgets('renders compassionate quote and sun icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SelfCompassionCard(
              quote:
                  '“El progreso no es lineal; cada pausa que te das cuenta como una victoria auténtica.”',
              subtitle: 'Recordatorio de autocompasión',
            ),
          ),
        ),
      );

      expect(
        find.text(
          '“El progreso no es lineal; cada pausa que te das cuenta como una victoria auténtica.”',
        ),
        findsOneWidget,
      );
      expect(find.text('Recordatorio de autocompasión'), findsOneWidget);
      expect(find.byIcon(Icons.wb_sunny_outlined), findsOneWidget);
    });
  });
}

