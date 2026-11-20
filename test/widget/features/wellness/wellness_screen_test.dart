import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/wellness/presentation/screens/wellness_screen.dart';

void main() {
  group('WellnessScreen Integration Widget Tests', () {
    Widget createTestApp() {
      return const ProviderScope(
        child: MaterialApp(
          home: WellnessScreen(),
        ),
      );
    }

    testWidgets('renders all screen components according to Figma design', (tester) async {
      await tester.pumpWidget(createTestApp());

      // 1. Header
      expect(find.text('mindUC'), findsOneWidget);
      expect(find.text('Bienestar'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none_outlined), findsOneWidget);

      // 2. Sanctuary Badge
      expect(find.text('SANCTUARY MODE'), findsOneWidget);

      // 3. Hero section
      expect(find.text('Tu espacio de bienestar ✨'), findsOneWidget);
      expect(find.text('Tómate una pausa consciente. Cada pequeño respiro renueva tu energía interior.'), findsOneWidget);

      // 4. Suggested exercise card
      expect(find.text('EJERCICIO SUGERIDO PARA TI HOY'), findsOneWidget);
      expect(find.text('Respiración 4–7–8'), findsOneWidget);
      expect(find.text('Comenzar (5 min)'), findsOneWidget);

      // 5. 2x2 grid of tools
      expect(find.text('Respiración'), findsOneWidget);
      expect(find.text('Diario personal'), findsOneWidget);
      expect(find.text('Psicólogo IA ✨'), findsOneWidget);
      expect(find.text('Concentración'), findsOneWidget);
    });

    testWidgets('renders Psicólogo IA tool with badge and proper information', (tester) async {
      await tester.pumpWidget(createTestApp());

      await tester.ensureVisible(find.text('Psicólogo IA ✨'));
      await tester.pumpAndSettle();

      expect(find.text('Psicólogo IA ✨'), findsOneWidget);
      expect(find.text('Gratis 24/7'), findsOneWidget);
    });
  });
}
