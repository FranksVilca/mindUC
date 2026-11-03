import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/focus_pomodoro/presentation/screens/pomodoro_screen.dart';

void main() {
  group('PomodoroScreen Integration Widget Tests', () {
    testWidgets('renders all screen components according to Figma design',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: PomodoroScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Cabecera
      expect(find.text('Minduc — Concentración\n(Pomodoro)'), findsOneWidget);
      expect(find.text('mindUC'), findsOneWidget);

      // Progreso de ciclos
      expect(find.text('Sesión de la tarde'), findsOneWidget);
      expect(find.text('Ciclo 2 de 4'), findsOneWidget);

      // Selector de intervalos
      expect(find.text('Enfoque'), findsOneWidget);
      expect(find.text('Corto (5m)'), findsOneWidget);
      expect(find.text('Largo (15m)'), findsOneWidget);

      // Tarjeta de temporizador y objetivo
      expect(find.text('OBJETIVO EN CURSO'), findsOneWidget);
      expect(find.text('Lectura Cap. 4 — Psicología Social'), findsOneWidget);
      expect(find.text('18:41'), findsOneWidget);
      expect(find.text('de 25:00 min'), findsOneWidget);
      expect(find.text('Iniciar enfoque'), findsOneWidget);

      // Ambiente sonoro
      expect(find.text('Ambiente sonoro'), findsOneWidget);
      expect(find.text('Audio relajante'), findsOneWidget);
      expect(find.text('Lluvia campus'), findsOneWidget);

      // Scroll para asegurar visibilidad del modo enfoque profundo
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Modo enfoque profundo
      expect(find.text('Modo enfoque profundo'), findsOneWidget);
      expect(find.text('3 apps silenciadas temporalmente'), findsOneWidget);
      expect(find.text('Instagram 🔒'), findsOneWidget);
    });

    testWidgets('toggles timer between Iniciar and Pausar enfoque',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: PomodoroScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Iniciar enfoque'), findsOneWidget);

      // Tap iniciar
      await tester.tap(find.text('Iniciar enfoque'));
      await tester.pump();

      expect(find.text('Pausar enfoque'), findsOneWidget);
      expect(find.text('Bloque activo'), findsOneWidget);

      // Tap pausar
      await tester.tap(find.text('Pausar enfoque'));
      await tester.pump();

      expect(find.text('Iniciar enfoque'), findsOneWidget);
      expect(find.text('En pausa'), findsOneWidget);
    });

    testWidgets('changing interval type updates timer duration',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: PomodoroScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Corto (5m)'));
      await tester.pumpAndSettle();

      expect(find.text('05:00'), findsOneWidget);
      expect(find.text('de 05:00 min'), findsOneWidget);
    });

    testWidgets('editing objective updates title on the card', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: PomodoroScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap editar objetivo
      await tester.tap(find.byTooltip('Editar objetivo'));
      await tester.pumpAndSettle();

      expect(find.text('Objetivo de Estudio'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Estudio Examen Final');
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(find.text('Estudio Examen Final'), findsOneWidget);
    });
  });
}

