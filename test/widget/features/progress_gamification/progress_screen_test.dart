import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/progress_gamification/presentation/screens/progress_screen.dart';

void main() {
  Widget createScreen() {
    return const ProviderScope(
      child: MaterialApp(
        home: ProgressScreen(),
      ),
    );
  }

  void configureViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  group('ProgressScreen Full Integration Tests', () {
    testWidgets(
        'renders all components: header, badge, streak, pauses, garden, intentions and reminder',
        (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      // 1. Cabecera serena
      expect(find.text('MINDUC'), findsOneWidget);
      expect(find.text('Gamificación Detallada'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);

      // 2. Insignia y título
      expect(find.text('🌱 Crecimiento consciente'), findsOneWidget);
      expect(find.text('Mi Progreso & Florecimiento'), findsOneWidget);
      expect(
        find.text('Celebrando cada paso hacia tu bienestar, a tu propio ritmo.'),
        findsOneWidget,
      );

      // 3. Racha de autocuidado activo (7 días)
      expect(find.text('RACHA DE AUTOCUIDADO ACTIVO'), findsOneWidget);
      expect(find.text('7 días'), findsOneWidget);
      expect(find.text('consecutivos'), findsOneWidget);
      expect(
        find.text('Tu brote de serenidad floreció hoy con tu pausa matutina.'),
        findsOneWidget,
      );
      expect(find.text('L'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);

      // 4. Momentos de pausa (4 métricas)
      expect(find.text('Momentos de pausa'), findsOneWidget);
      expect(find.text('145 min'), findsOneWidget);
      expect(find.text('12 sesiones'), findsOneWidget);
      expect(find.text('9 reflexiones'), findsOneWidget);
      expect(find.text('85%'), findsOneWidget);

      // 5. Jardín de logros (3 de 4)
      expect(find.text('Jardín de logros'), findsOneWidget);
      expect(find.text('3 de 4'), findsOneWidget);
      expect(find.text('Semilla de Paz'), findsOneWidget);
      expect(find.text('Mente Serena'), findsOneWidget);
      expect(find.text('Voz Auténtica'), findsOneWidget);
      expect(find.text('Foco Lúcido'), findsOneWidget);
      expect(find.text('4h de 5h (80%)'), findsOneWidget);

      // 6. Intenciones de la semana
      expect(find.text('Intenciones de la semana'), findsOneWidget);
      expect(
        find.text('Hacer 3 pausas activas antes del almuerzo'),
        findsOneWidget,
      );
      expect(find.text('3 de 3 completadas hoy'), findsOneWidget);
      expect(
        find.text('Tomar un paseo consciente de 10 min'),
        findsOneWidget,
      );
      expect(find.text('2 / 3 días'), findsOneWidget);

      // 7. Recordatorio compasivo
      expect(
        find.text(
          '“El progreso no es lineal; cada pausa que te das cuenta como una victoria auténtica.”',
        ),
        findsOneWidget,
      );
      expect(find.text('Recordatorio de autocompasión'), findsOneWidget);
    });

    testWidgets('toggles weekly intention progress reactively on screen',
        (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      // Inicialmente 2 / 3 días
      expect(find.text('2 / 3 días'), findsOneWidget);

      // Tocar para registrar avance
      await tester.tap(find.text('Tomar un paseo consciente de 10 min'));
      await tester.pumpAndSettle();

      // Debe estar completado: 3 de 3 días
      expect(find.text('3 de 3 días'), findsOneWidget);
      expect(find.text('2 / 3 días'), findsNothing);

      // Tocar nuevamente para revertir
      await tester.tap(find.text('Tomar un paseo consciente de 10 min'));
      await tester.pumpAndSettle();

      expect(find.text('2 / 3 días'), findsOneWidget);
    });
  });
}

