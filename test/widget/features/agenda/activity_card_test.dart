import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/agenda/domain/entities/agenda_activity.dart';
import 'package:minduc/features/agenda/domain/entities/agenda_category.dart';
import 'package:minduc/features/agenda/presentation/widgets/activity_card.dart';

void main() {
  group('ActivityCard Widget Tests', () {
    testWidgets('renders completed activity with checkmark and strikethrough',
        (tester) async {
      bool toggleCalled = false;

      final activity = AgendaActivity(
        id: 'act-1',
        title: 'Meditación matutina y respiración',
        subtitle: '10 min de enfoque guiado para iniciar el día en calma.',
        scheduledDateTime: DateTime(2024, 10, 24, 8, 0),
        category: AgendaCategory.autocuidado,
        isCompleted: true,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActivityCard(
              activity: activity,
              onToggleComplete: () => toggleCalled = true,
            ),
          ),
        ),
      );

      expect(find.text('08:00 AM'), findsOneWidget);
      expect(find.text('Autocuidado'), findsOneWidget);
      expect(find.text('Meditación matutina y respiración'), findsOneWidget);
      expect(
        find.text('10 min de enfoque guiado para iniciar el día en calma.'),
        findsOneWidget,
      );

      // Icono de checkmark presente
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);

      // Tocar el selector circular
      await tester.tap(find.byIcon(Icons.check_rounded));
      await tester.pump();

      expect(toggleCalled, isTrue);
    });

    testWidgets('renders pending activity with empty circle and normal title',
        (tester) async {
      bool toggleCalled = false;

      final activity = AgendaActivity(
        id: 'act-3',
        title: 'Caminata al aire libre sin pantallas',
        subtitle: '25 min en el parque para despejar la vista y desconectar.',
        scheduledDateTime: DateTime(2024, 10, 24, 16, 0),
        category: AgendaCategory.saludMental,
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActivityCard(
              activity: activity,
              onToggleComplete: () => toggleCalled = true,
            ),
          ),
        ),
      );

      expect(find.text('16:00 PM'), findsOneWidget);
      expect(find.text('Salud mental'), findsOneWidget);
      expect(find.text('Caminata al aire libre sin pantallas'), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsNothing);

      // Tocar el círculo selector vacío
      await tester.tap(find.byType(AnimatedContainer));
      await tester.pump();

      expect(toggleCalled, isTrue);
    });
  });
}

