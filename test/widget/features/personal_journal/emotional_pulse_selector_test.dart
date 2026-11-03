import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/personal_journal/domain/entities/journal_mood_pulse.dart';
import 'package:minduc/features/personal_journal/presentation/widgets/emotional_pulse_selector.dart';

void main() {
  group('EmotionalPulseSelector Widget Tests', () {
    testWidgets('renders all 5 pulses and invokes onPulseSelected on tap',
        (tester) async {
      JournalMoodPulse selected = JournalMoodPulse.enCalma;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmotionalPulseSelector(
              selectedPulse: selected,
              onPulseSelected: (pulse) => selected = pulse,
            ),
          ),
        ),
      );

      expect(find.textContaining('¿Cómo late tu corazón'), findsOneWidget);
      expect(find.textContaining('Sintoniza tu'), findsOneWidget);

      expect(find.text('Agradecida'), findsOneWidget);
      expect(find.text('En calma'), findsOneWidget);
      expect(find.text('Reflexiva'), findsOneWidget);
      expect(find.text('Cansada'), findsOneWidget);
      expect(find.text('Abrumada'), findsOneWidget);

      // Tap Agradecida
      await tester.tap(find.text('Agradecida'));
      await tester.pump();
      expect(selected, JournalMoodPulse.agradecida);

      // Tap Abrumada
      await tester.tap(find.text('Abrumada'));
      await tester.pump();
      expect(selected, JournalMoodPulse.abrumada);
    });
  });
}

