import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/profile/presentation/screens/profile_screen.dart';

void main() {
  void configureViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Widget createScreen() {
    return const ProviderScope(
      child: MaterialApp(
        home: ProfileScreen(),
      ),
    );
  }

  group('ProfileScreen Full Integration Tests', () {
    testWidgets('renders all screen components according to Figma design', (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      // 1. Header
      expect(find.text('mindUC'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

      // 2. Student identity card
      expect(find.text('Camila Soto'), findsOneWidget);
      expect(find.text('Psicología'), findsOneWidget);
      expect(find.text('camila.soto@uc.cl'), findsOneWidget);
      expect(find.byKey(const Key('profile_presence_dot')), findsOneWidget);

      // 3. Wellness preferences
      expect(find.text('PREFERENCIAS DE BIENESTAR'), findsOneWidget);
      expect(find.text('Sonido ambiental predeterminado'), findsOneWidget);
      expect(find.text('Lluvia suave en el bosque'), findsOneWidget);
      expect(find.text('Técnica de respiración favorita'), findsOneWidget);
      expect(find.text('Caja 4–4–4'), findsOneWidget);
      expect(find.text('Recordatorios conscientes'), findsOneWidget);
      expect(find.byKey(const Key('conscious_reminders_switch')), findsOneWidget);

      // 4. Institutional support
      expect(find.text('SOPORTE INSTITUCIONAL'), findsOneWidget);
      expect(find.text('Línea de Apoyo Psicológico'), findsOneWidget);
      expect(find.text('Anexo universitario confidencial'), findsOneWidget);
      expect(find.byKey(const Key('institutional_call_button')), findsOneWidget);

      // 5. Logout button
      expect(find.text('Cerrar sesión en este dispositivo'), findsOneWidget);
    });

    testWidgets('toggles conscious reminders switch and updates reactively', (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      final switchFinder = find.byKey(const Key('conscious_reminders_switch'));
      expect(switchFinder, findsOneWidget);

      // Initial state is true
      Switch switchWidget = tester.widget<Switch>(switchFinder);
      expect(switchWidget.value, isTrue);

      // Toggle switch
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // State is now false
      switchWidget = tester.widget<Switch>(switchFinder);
      expect(switchWidget.value, isFalse);
    });

    testWidgets('opens ambient sound modal and selects a different sound', (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.text('Lluvia suave en el bosque'), findsOneWidget);

      // Tap on ambient sound preference
      await tester.tap(find.text('Sonido ambiental predeterminado'));
      await tester.pumpAndSettle();

      // Modal options visible
      expect(find.text('Bosque al atardecer'), findsOneWidget);

      // Select Bosque al atardecer
      await tester.tap(find.text('Bosque al atardecer'));
      await tester.pumpAndSettle();

      // Modal closes and screen updates
      expect(find.text('Bosque al atardecer'), findsOneWidget);
    });

    testWidgets('opens support contact modal on Llamar tap', (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('institutional_call_button')));
      await tester.pumpAndSettle();

      expect(find.text('*4000'), findsOneWidget);
      expect(find.text('+56 9 1234 5678'), findsOneWidget);
      expect(find.text('Copiar anexo'), findsOneWidget);
    });

    testWidgets('opens logout dialog when logout button is pressed', (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('profile_logout_button')));
      await tester.pumpAndSettle();

      expect(find.text('¿Cerrar sesión en este dispositivo?'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Cerrar sesión'), findsOneWidget);

      // Cancel dismissal
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.text('¿Cerrar sesión en este dispositivo?'), findsNothing);
      expect(find.text('Camila Soto'), findsOneWidget);
    });
  });
}
