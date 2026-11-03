import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/theme/mind_theme.dart';
import 'package:minduc/features/home/domain/entities/mood_type.dart';
import 'package:minduc/features/home/presentation/widgets/mood_selector_row.dart';

void main() {
  group('MoodSelectorRow Widget Tests', () {
    testWidgets('renders all 5 moods and triggers onMoodSelected on tap', (tester) async {
      MoodType? selectedMood;

      await tester.pumpWidget(
        MaterialApp(
          theme: MindTheme.lightTheme,
          home: Scaffold(
            body: MoodSelectorRow(
              selectedMood: MoodType.calma,
              onMoodSelected: (mood) => selectedMood = mood,
            ),
          ),
        ),
      );

      // Verify header texts
      expect(find.text('Tu estado de ánimo'), findsOneWidget);
      expect(find.text('Selecciona uno'), findsOneWidget);

      // Verify 5 mood labels
      expect(find.text('Calma'), findsOneWidget);
      expect(find.text('Feliz'), findsOneWidget);
      expect(find.text('Ansiosa'), findsOneWidget);
      expect(find.text('Cansada'), findsOneWidget);
      expect(find.text('Enérgica'), findsOneWidget);

      // Tap on Feliz
      await tester.tap(find.text('Feliz'));
      await tester.pumpAndSettle();

      expect(selectedMood, equals(MoodType.feliz));
    });
  });
}

