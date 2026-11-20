import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/agenda/domain/entities/agenda_category.dart';
import 'package:minduc/features/agenda/presentation/widgets/activity_create_modal.dart';

void main() {
  group('ActivityCreateModal Widget Tests', () {
    testWidgets('captures input and calls onSave on confirm', (tester) async {
      String? savedTitle;
      String? savedSubtitle;
      AgendaCategory? savedCategory;
      int? savedReminderMinutes;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ActivityCreateModal.show(
                    context,
                    defaultDate: DateTime(2024, 10, 24),
                    onSave: (title, subtitle, scheduled, category, reminder, reminders) {
                      savedTitle = title;
                      savedSubtitle = subtitle;
                      savedCategory = category;
                      savedReminderMinutes = reminder;
                    },
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      // Abrir modal
      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Nueva actividad consciente'), findsOneWidget);
      expect(find.text('Guardar actividad'), findsOneWidget);

      // Ingresar título y descripción
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      await tester.enterText(textFields.first, 'Yoga matutino sereno');
      await tester.enterText(
        textFields.last,
        '15 min de estiramientos para soltar tensión muscular.',
      );

      // Cambiar categoría a 'Salud mental'
      await tester.tap(find.text('Salud mental'));
      await tester.pumpAndSettle();

      // Guardar
      await tester.ensureVisible(find.text('Guardar actividad'));
      await tester.tap(find.text('Guardar actividad'));
      await tester.pumpAndSettle();

      expect(savedTitle, 'Yoga matutino sereno');
      expect(
        savedSubtitle,
        '15 min de estiramientos para soltar tensión muscular.',
      );
      expect(savedCategory, AgendaCategory.saludMental);
      expect(savedReminderMinutes, 0);
    });

    testWidgets('shows snackbar when title is empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ActivityCreateModal.show(
                    context,
                    defaultDate: DateTime(2024, 10, 24),
                    onSave: (_, __, ___, ____, _____, ______) {},
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Intentar guardar con campos vacíos
      await tester.ensureVisible(find.text('Guardar actividad'));
      await tester.tap(find.text('Guardar actividad'));
      await tester.pump();

      expect(
        find.text('Por favor escribe un título para tu actividad.'),
        findsOneWidget,
      );
    });

    testWidgets('allows selecting multiple reminder alarms with checkboxes', (tester) async {
      int? savedReminderMinutes;
      List<int>? savedReminderList;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ActivityCreateModal.show(
                    context,
                    defaultDate: DateTime(2024, 10, 24),
                    onSave: (title, subtitle, scheduled, category, reminder, reminders) {
                      savedReminderMinutes = reminder;
                      savedReminderList = reminders;
                    },
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'Sesión de estudio');

      // Seleccionar recordatorios adicionales con checkbox (15 minutos antes y 2 horas antes)
      final checkbox15 = find.byKey(const Key('activity_reminder_checkbox_15'));
      expect(checkbox15, findsOneWidget);
      await tester.ensureVisible(checkbox15);
      await tester.tap(checkbox15);
      await tester.pumpAndSettle();

      final checkbox120 = find.byKey(const Key('activity_reminder_checkbox_120'));
      expect(checkbox120, findsOneWidget);
      await tester.ensureVisible(checkbox120);
      await tester.tap(checkbox120);
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Guardar actividad'));
      await tester.tap(find.text('Guardar actividad'));
      await tester.pumpAndSettle();

      expect(savedReminderList, containsAll([15, 120, 0]));
      expect(savedReminderMinutes, isNotNull);
    });
  });
}

