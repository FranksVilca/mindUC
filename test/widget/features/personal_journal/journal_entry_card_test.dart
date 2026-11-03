import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/personal_journal/domain/entities/journal_entry.dart';
import 'package:minduc/features/personal_journal/domain/entities/journal_mood_pulse.dart';
import 'package:minduc/features/personal_journal/presentation/widgets/journal_entry_card.dart';
import 'package:minduc/features/personal_journal/presentation/widgets/journal_privacy_banner.dart';

void main() {
  group('JournalPrivacyBanner Widget Tests', () {
    testWidgets('renders sacred space badge, title, and encrypted device notice',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: JournalPrivacyBanner(),
          ),
        ),
      );

      expect(find.text('ESPACIO SAGRADO'), findsOneWidget);
      expect(find.text('Mi Diario Personal'), findsOneWidget);
      expect(
        find.textContaining('protegidos y cifrados en tu dispositivo'),
        findsOneWidget,
      );
    });
  });

  group('JournalEntryCard Widget Tests', () {
    testWidgets('renders emotion badge, title, snippet, privacy and reading time',
        (tester) async {
      bool editCalled = false;
      bool deleteCalled = false;

      final entry = JournalEntry(
        id: 'entry-1',
        title: 'Aprender a soltar lo que no puedo controlar',
        content:
            'Hoy me di cuenta de que preocuparme por el resultado final del proyecto solo me generaba angustia. Decidí enfocarme en los 30 minutos...',
        moodPulse: JournalMoodPulse.enCalma,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: JournalEntryCard(
                entry: entry,
                onEdit: () => editCalled = true,
                onDelete: () => deleteCalled = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('🌸 En calma'), findsOneWidget);
      expect(find.text('Aprender a soltar lo que no puedo controlar'),
          findsOneWidget);
      expect(find.text('Solo visible en este teléfono'), findsOneWidget);
      expect(find.text('1 min de lectura'), findsOneWidget);

      // Tap editar
      await tester.tap(find.byTooltip('Editar reflexión'));
      await tester.pump();
      expect(editCalled, isTrue);

      // Tap menú de opciones y eliminar
      await tester.tap(find.byTooltip('Opciones'));
      await tester.pumpAndSettle();

      expect(find.text('Eliminar'), findsOneWidget);
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();

      expect(find.text('¿Eliminar huella interior?'), findsOneWidget);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Eliminar'));
      await tester.pumpAndSettle();

      expect(deleteCalled, isTrue);
    });
  });
}

