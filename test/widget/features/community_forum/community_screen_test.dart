import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/community_forum/presentation/screens/community_screen.dart';

void main() {
  Widget createScreen() {
    return const ProviderScope(
      child: MaterialApp(
        home: CommunityScreen(),
      ),
    );
  }

  void configureViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  group('CommunityScreen Widget Integration Tests', () {
    testWidgets(
        'renders header, safe banner, new post button, filter chips and initial posts',
        (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      // Cabecera serena
      expect(find.text('mindUC'), findsOneWidget);
      expect(find.text('Minduc — Comunidad'), findsOneWidget);

      // Banner espacio seguro
      expect(find.text('ESPACIO SEGURO UC'), findsOneWidget);
      expect(find.text('Comunidad UC Consciente'), findsOneWidget);
      expect(
        find.textContaining('Identidad protegida: todos los alias son ficticios'),
        findsOneWidget,
      );

      // Botón de acción principal
      expect(find.text('+ Compartir reflexión anónima'), findsOneWidget);

      // Filtros por sentir
      expect(find.text('Filtrar por sentir'), findsOneWidget);
      expect(find.text('3 hilos activos'), findsOneWidget);
      expect(find.text('Todo'), findsOneWidget);
      expect(find.text('Estrés académico'), findsOneWidget);
      expect(find.text('Hábito saludable'), findsOneWidget);

      // Hilos iniciales de Figma visibles en el viewport
      expect(find.text('@BúhoCurioso'), findsOneWidget);
      expect(find.text('@BroteCalmo'), findsOneWidget);
      expect(find.text('@LluviaSuave'), findsOneWidget);
    });

    testWidgets('filters posts interactively when tapping a mood filter chip',
        (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      // Verificar que los 3 hilos están presentes inicialmente
      expect(find.text('@BúhoCurioso'), findsOneWidget);
      expect(find.text('@BroteCalmo'), findsOneWidget);
      expect(find.text('@LluviaSuave'), findsOneWidget);

      // Tocar filtro "Hábito saludable"
      await tester.tap(find.text('Hábito saludable'));
      await tester.pumpAndSettle();

      // Ahora solo debe mostrarse el hilo de @BroteCalmo
      expect(find.text('@BroteCalmo'), findsOneWidget);
      expect(find.text('@BúhoCurioso'), findsNothing);
      expect(find.text('@LluviaSuave'), findsNothing);

      // Volver a "Todo"
      await tester.tap(find.text('Todo'));
      await tester.pumpAndSettle();

      expect(find.text('@BúhoCurioso'), findsOneWidget);
      expect(find.text('@BroteCalmo'), findsOneWidget);
      expect(find.text('@LluviaSuave'), findsOneWidget);
    });

    testWidgets('toggles reaction support count interactively on post card',
        (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      // Conteo inicial de soporte en @BúhoCurioso es 42
      expect(find.text('42'), findsOneWidget);

      // Tocar reacción de soporte
      await tester.tap(find.text('42'));
      await tester.pumpAndSettle();

      // Debe incrementarse a 43
      expect(find.text('43'), findsOneWidget);
      expect(find.text('42'), findsNothing);

      // Tocar nuevamente para retirar reacción
      await tester.tap(find.text('43'));
      await tester.pumpAndSettle();

      // Debe volver a 42
      expect(find.text('42'), findsOneWidget);
      expect(find.text('43'), findsNothing);
    });

    testWidgets(
        'opens creation modal and publishes a new anonymous post into timeline',
        (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.text('3 hilos activos'), findsOneWidget);

      // Tocar "+ Compartir reflexión anónima"
      await tester.tap(find.text('+ Compartir reflexión anónima'));
      await tester.pumpAndSettle();

      expect(find.text('Compartir reflexión anónima'), findsOneWidget);

      // Escribir reflexión
      await tester.enterText(
        find.byType(TextField),
        'Hoy me tomé una pausa consciente en el Campus San Joaquín y todo mejoró.',
      );
      await tester.pump();

      // Publicar en comunidad
      await tester.tap(find.text('Publicar en comunidad'));
      await tester.pumpAndSettle();

      // Verificar que el modal se cerró
      expect(find.text('Compartir reflexión anónima'), findsNothing);

      // El nuevo hilo está visible en la cronología
      expect(
        find.text(
          'Hoy me tomé una pausa consciente en el Campus San Joaquín y todo mejoró.',
        ),
        findsOneWidget,
      );

      // Conteo de hilos activos subió a 4
      expect(find.text('4 hilos activos'), findsOneWidget);
    });
  });
}
