import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/personal_journal/domain/entities/journal_entry.dart';
import 'package:minduc/features/personal_journal/domain/entities/journal_mood_pulse.dart';
import 'package:minduc/features/personal_journal/presentation/widgets/journal_entry_edit_modal.dart';

void main() {
  group('JournalEntryEditModal Widget Tests', () {
    testWidgets('creates a new reflection and invokes onSave callback',
        (tester) async {
      String savedTitle = '';
      String savedContent = '';
      JournalMoodPulse savedPulse = JournalMoodPulse.cansada;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  JournalEntryEditModal.show(
                    context,
                    defaultPulse: JournalMoodPulse.enCalma,
                    onSave: (title, content, pulse) {
                      savedTitle = title;
                      savedContent = content;
                      savedPulse = pulse;
                    },
                  );
                },
                child: const Text('Abrir'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();

      expect(find.text('Nueva entrada reflexiva'), findsOneWidget);

      // Ingresar título y contenido
      await tester.enterText(
          find.byType(TextField).first, 'Mi reflexión matutina');
      await tester.enterText(
          find.byType(TextField).last, 'Hoy agradezco la paz del campus.');

      // Seleccionar chip Agradecida
      await tester.tap(find.text('✨ Agradecida'));
      await tester.pumpAndSettle();

      // Guardar
      await tester.tap(find.text('Guardar reflexión'));
      await tester.pumpAndSettle();

      expect(savedTitle, 'Mi reflexión matutina');
      expect(savedContent, 'Hoy agradezco la paz del campus.');
      expect(savedPulse, JournalMoodPulse.agradecida);
      expect(find.text('Nueva entrada reflexiva'), findsNothing);
    });

    testWidgets('preloads existing entry in editing mode and saves changes',
        (tester) async {
      final existing = JournalEntry(
        id: '123',
        title: 'Título anterior',
        content: 'Contenido previo',
        moodPulse: JournalMoodPulse.reflexiva,
        createdAt: DateTime.now(),
      );

      String updatedTitle = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  JournalEntryEditModal.show(
                    context,
                    existingEntry: existing,
                    defaultPulse: JournalMoodPulse.enCalma,
                    onSave: (title, content, pulse) {
                      updatedTitle = title;
                    },
                  );
                },
                child: const Text('Editar'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Editar'));
      await tester.pumpAndSettle();

      expect(find.text('Editar reflexión'), findsOneWidget);
      expect(find.text('Título anterior'), findsOneWidget);
      expect(find.text('Contenido previo'), findsOneWidget);

      await tester.enterText(
          find.byType(TextField).first, 'Título modificado');
      await tester.tap(find.text('Guardar cambios'));
      await tester.pumpAndSettle();

      expect(updatedTitle, 'Título modificado');
    });
  });
}

