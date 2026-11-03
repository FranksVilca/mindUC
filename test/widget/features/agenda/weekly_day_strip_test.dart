import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/agenda/domain/entities/agenda_activity.dart';
import 'package:minduc/features/agenda/domain/entities/agenda_category.dart';
import 'package:minduc/features/agenda/presentation/widgets/weekly_day_strip.dart';

void main() {
  group('WeeklyDayStrip Widget Tests', () {
    testWidgets('renders all 7 days of the week and selects a day on tap',
        (tester) async {
      final selectedDate = DateTime(2024, 10, 24); // Jueves 24
      DateTime? tappedDate;

      final activities = [
        AgendaActivity(
          id: '1',
          title: 'A1',
          subtitle: 'S1',
          scheduledDateTime: DateTime(2024, 10, 24, 8, 0),
          category: AgendaCategory.autocuidado,
          createdAt: DateTime.now(),
        ),
        AgendaActivity(
          id: '2',
          title: 'A2',
          subtitle: 'S2',
          scheduledDateTime: DateTime(2024, 10, 24, 11, 0),
          category: AgendaCategory.estudioTrabajo,
          createdAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeeklyDayStrip(
              selectedDate: selectedDate,
              activities: activities,
              onDateSelected: (d) => tappedDate = d,
            ),
          ),
        ),
      );

      // Verificar que los 7 días están presentes
      expect(find.text('Lun'), findsOneWidget);
      expect(find.text('Mar'), findsOneWidget);
      expect(find.text('Mié'), findsOneWidget);
      expect(find.text('Jue'), findsOneWidget);
      expect(find.text('Vie'), findsOneWidget);
      expect(find.text('Sáb'), findsOneWidget);
      expect(find.text('Dom'), findsOneWidget);

      expect(find.text('21'), findsOneWidget);
      expect(find.text('24'), findsOneWidget);
      expect(find.text('27'), findsOneWidget);

      // Tocar en 'Vie 25'
      await tester.tap(find.text('25'));
      await tester.pump();

      expect(tappedDate, isNotNull);
      expect(tappedDate!.day, 25);
    });
  });
}

