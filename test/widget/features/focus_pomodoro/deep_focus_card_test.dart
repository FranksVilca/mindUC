import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/focus_pomodoro/presentation/widgets/deep_focus_card.dart';

void main() {
  group('DeepFocusCard Widget Tests', () {
    testWidgets('renders title, app chips and toggles switch', (tester) async {
      bool toggleValue = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeepFocusCard(
              isEnabled: true,
              onToggle: (val) => toggleValue = val,
            ),
          ),
        ),
      );

      expect(find.text('Modo enfoque profundo'), findsOneWidget);
      expect(find.text('3 apps silenciadas temporalmente'), findsOneWidget);
      expect(find.text('Instagram 🔒'), findsOneWidget);
      expect(find.text('TikTok 🔒'), findsOneWidget);
      expect(find.text('WhatsApp 🔒'), findsOneWidget);

      // Alternar switch
      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(toggleValue, isFalse);
    });

    testWidgets('tapping info opens ethical guidance dialog under Principle VII',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeepFocusCard(
              isEnabled: true,
              onToggle: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Modo enfoque profundo'));
      await tester.pumpAndSettle();

      expect(find.text('Enfoque Consciente'), findsOneWidget);
      expect(find.textContaining('Principio VII'), findsOneWidget);

      await tester.tap(find.text('Comprendido'));
      await tester.pumpAndSettle();

      expect(find.text('Enfoque Consciente'), findsNothing);
    });
  });
}

