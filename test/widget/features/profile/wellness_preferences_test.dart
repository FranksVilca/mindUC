import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/profile/domain/entities/wellness_preferences.dart';
import 'package:minduc/features/profile/presentation/widgets/wellness_preferences_card.dart';

void main() {
  group('WellnessPreferencesCard Widget Tests', () {
    testWidgets('renders all 3 preferences and responds to switch toggle', (tester) async {
      bool soundTapped = false;
      bool techniqueTapped = false;
      bool switchValue = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return WellnessPreferencesCard(
                  preferences: WellnessPreferences(
                    defaultAmbientSound: 'Lluvia suave en el bosque',
                    favoriteBreathingTechnique: 'Caja 4–4–4',
                    consciousRemindersEnabled: switchValue,
                  ),
                  onSoundTap: () => soundTapped = true,
                  onTechniqueTap: () => techniqueTapped = true,
                  onRemindersChanged: (val) {
                    setState(() => switchValue = val);
                  },
                );
              },
            ),
          ),
        ),
      );

      // Section header
      expect(find.text('PREFERENCIAS DE BIENESTAR'), findsOneWidget);

      // Option 1: Ambient sound
      expect(find.text('Sonido ambiental predeterminado'), findsOneWidget);
      expect(find.text('Lluvia suave en el bosque'), findsOneWidget);
      await tester.tap(find.text('Sonido ambiental predeterminado'));
      await tester.pump();
      expect(soundTapped, isTrue);

      // Option 2: Breathing technique
      expect(find.text('Técnica de respiración favorita'), findsOneWidget);
      expect(find.text('Caja 4–4–4'), findsOneWidget);
      await tester.tap(find.text('Técnica de respiración favorita'));
      await tester.pump();
      expect(techniqueTapped, isTrue);

      // Option 3: Conscious reminders switch
      expect(find.text('Recordatorios conscientes'), findsOneWidget);
      expect(find.text('Pausas cada 2 horas de estudio'), findsOneWidget);

      final switchFinder = find.byKey(const Key('conscious_reminders_switch'));
      expect(switchFinder, findsOneWidget);

      // Toggle switch
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();
      expect(switchValue, isFalse);
    });
  });
}

