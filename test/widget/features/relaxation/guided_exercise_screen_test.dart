import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/relaxation/presentation/controllers/relaxation_controller.dart';
import 'package:minduc/features/relaxation/presentation/screens/guided_exercise_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createScreen({required ProviderContainer container}) {
    return UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        home: GuidedExerciseScreen(),
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

  group('GuidedExerciseScreen Widget Tests', () {
    testWidgets('renders all step guidance elements: header, body visualizer, instruction, tips and controls',
        (tester) async {
      configureViewport(tester);
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Iniciar actividad de cuello y pausar para controlar avance manual en el test
      container.read(relaxationControllerProvider.notifier).startActivity('neck_stretch');
      container.read(relaxationControllerProvider.notifier).togglePlayPause();

      await tester.pumpWidget(createScreen(container: container));
      await tester.pumpAndSettle();

      // 1. Cabecera y contador de pasos
      expect(find.text('Estiramiento de cuello'), findsWidgets);
      expect(find.text('Paso 1 de 5'), findsOneWidget);

      // 2. Visualizador y etiquetas de foco anatómico
      expect(find.textContaining('Zona activa: Cuello lateral izquierdo'), findsOneWidget);
      expect(find.textContaining('Dirección: Hacia el hombro derecho'), findsOneWidget);
      expect(find.text('25s'), findsOneWidget);

      // 3. Tarjeta de instrucción y ergonomía
      expect(find.text('Paso 1: Inclinación lateral derecha'), findsOneWidget);
      expect(
        find.textContaining('Inclina suavemente la cabeza hacia el hombro derecho'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Mantén los hombros bajos y relajados'),
        findsOneWidget,
      );

      // 4. Barra de controles
      expect(find.byKey(const Key('btn_exercise_toggle_play')), findsOneWidget);
      expect(find.byKey(const Key('btn_exercise_next_step')), findsOneWidget);
      expect(find.byKey(const Key('btn_exercise_prev_step')), findsOneWidget);
      expect(find.byKey(const Key('btn_exercise_reset_step')), findsOneWidget);
    });

    testWidgets('advancing through steps updates instruction and finishing shows summary dialog',
        (tester) async {
      configureViewport(tester);
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(relaxationControllerProvider.notifier).startActivity('neck_stretch');
      container.read(relaxationControllerProvider.notifier).togglePlayPause();

      await tester.pumpWidget(createScreen(container: container));
      await tester.pumpAndSettle();

      // Avanzar al paso 2
      await tester.tap(find.byKey(const Key('btn_exercise_next_step')));
      await tester.pumpAndSettle();

      expect(find.text('Paso 2 de 5'), findsOneWidget);
      expect(find.text('Paso 2: Sostén consciente'), findsOneWidget);

      // Avanzar pasos 3, 4, 5
      await tester.tap(find.byKey(const Key('btn_exercise_next_step'))); // paso 3
      await tester.pumpAndSettle();
      expect(find.text('Paso 3 de 5'), findsOneWidget);

      await tester.tap(find.byKey(const Key('btn_exercise_next_step'))); // paso 4
      await tester.pumpAndSettle();
      expect(find.text('Paso 4 de 5'), findsOneWidget);

      await tester.tap(find.byKey(const Key('btn_exercise_next_step'))); // paso 5
      await tester.pumpAndSettle();
      expect(find.text('Paso 5 de 5'), findsOneWidget);
      expect(find.text('Paso 5: Movilidad y semicírculos suaves'), findsOneWidget);

      // Culminar paso 5
      await tester.tap(find.byKey(const Key('btn_exercise_next_step')));
      await tester.pumpAndSettle();

      // Verifica diálogo de felicitación y métricas
      expect(find.text('¡Pausa completada con éxito! ✨'), findsOneWidget);
      expect(find.text('Estiramiento de cuello'), findsWidgets);
      expect(find.text('Volver a Relajación'), findsOneWidget);
      expect(find.text('Repetir este ejercicio'), findsOneWidget);
    });
  });
}
