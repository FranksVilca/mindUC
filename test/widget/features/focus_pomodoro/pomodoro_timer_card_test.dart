import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/focus_pomodoro/domain/entities/pomodoro_interval_type.dart';
import 'package:minduc/features/focus_pomodoro/domain/entities/pomodoro_state.dart';
import 'package:minduc/features/focus_pomodoro/presentation/widgets/interval_selector_row.dart';
import 'package:minduc/features/focus_pomodoro/presentation/widgets/pomodoro_timer_card.dart';

void main() {
  group('IntervalSelectorRow Widget Tests', () {
    testWidgets('renders all three interval options and triggers onTypeSelected',
        (tester) async {
      PomodoroIntervalType selected = PomodoroIntervalType.focus;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IntervalSelectorRow(
              selectedType: selected,
              onTypeSelected: (type) => selected = type,
            ),
          ),
        ),
      );

      expect(find.text('Enfoque'), findsOneWidget);
      expect(find.text('Corto (5m)'), findsOneWidget);
      expect(find.text('Largo (15m)'), findsOneWidget);

      await tester.tap(find.text('Corto (5m)'));
      await tester.pumpAndSettle();

      expect(selected, PomodoroIntervalType.shortBreak);
    });
  });

  group('PomodoroTimerCard Widget Tests', () {
    testWidgets('renders objective, digital timer, and triggers play/pause',
        (tester) async {
      bool toggleCalled = false;
      bool resetCalled = false;
      bool skipCalled = false;
      bool editCalled = false;

      const state = PomodoroState(
        currentObjective: 'Lectura Cap. 4 — Psicología Social',
        remainingSeconds: 1500,
        totalSeconds: 1500,
        isRunning: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: PomodoroTimerCard(
                state: state,
                onToggleTimer: () => toggleCalled = true,
                onResetInterval: () => resetCalled = true,
                onSkipInterval: () => skipCalled = true,
                onEditObjective: () => editCalled = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('OBJETIVO EN CURSO'), findsOneWidget);
      expect(find.text('Lectura Cap. 4 — Psicología Social'), findsOneWidget);
      expect(find.text('25:00'), findsOneWidget);
      expect(find.text('de 25:00 min'), findsOneWidget);
      expect(find.text('Bloque activo'), findsOneWidget);
      expect(find.text('Pausar enfoque'), findsOneWidget);

      // Tap pause
      await tester.tap(find.text('Pausar enfoque'));
      await tester.pump();
      expect(toggleCalled, isTrue);

      // Tap reset
      await tester.tap(find.byTooltip('Reiniciar intervalo'));
      await tester.pump();
      expect(resetCalled, isTrue);

      // Tap skip
      await tester.tap(find.byTooltip('Saltar intervalo'));
      await tester.pump();
      expect(skipCalled, isTrue);

      // Tap edit
      await tester.tap(find.byTooltip('Editar objetivo'));
      await tester.pump();
      expect(editCalled, isTrue);
    });

    testWidgets('shows Iniciar enfoque and En pausa when not running',
        (tester) async {
      const state = PomodoroState(
        remainingSeconds: 1500,
        totalSeconds: 1500,
        isRunning: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: PomodoroTimerCard(
                state: state,
                onToggleTimer: () {},
                onResetInterval: () {},
                onSkipInterval: () {},
                onEditObjective: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('En pausa'), findsOneWidget);
      expect(find.text('Iniciar enfoque'), findsOneWidget);
    });
  });
}
