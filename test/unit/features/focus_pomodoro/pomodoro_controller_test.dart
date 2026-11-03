import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/focus_pomodoro/domain/entities/pomodoro_interval_type.dart';
import 'package:minduc/features/focus_pomodoro/presentation/controllers/pomodoro_controller.dart';

void main() {
  group('PomodoroNotifier Unit Tests', () {
    late PomodoroNotifier controller;

    setUp(() {
      controller = PomodoroNotifier();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Initial state reflects Figma mockup specifications', () {
      final state = controller.state;
      expect(state.sessionTitle, 'Sesión de la tarde');
      expect(state.currentCycle, 2);
      expect(state.totalCycles, 4);
      expect(state.intervalType, PomodoroIntervalType.focus);
      expect(state.remainingSeconds, 1121); // 18:41
      expect(state.totalSeconds, 1500); // 25:00
      expect(state.isRunning, isFalse);
      expect(state.formattedRemainingTime, '18:41');
      expect(state.formattedTotalTime, 'de 25:00 min');
      expect(state.currentObjective, 'Lectura Cap. 4 — Psicología Social');
      expect(state.selectedSoundscapeId, 'rain');
      expect(state.isSoundscapePlaying, isTrue);
      expect(state.soundscapeVolume, 0.7);
      expect(state.isDeepFocusEnabled, isTrue);
    });

    test('startTimer, pauseTimer and toggleTimer manage running state', () {
      expect(controller.state.isRunning, isFalse);

      controller.startTimer();
      expect(controller.state.isRunning, isTrue);

      controller.pauseTimer();
      expect(controller.state.isRunning, isFalse);

      controller.toggleTimer();
      expect(controller.state.isRunning, isTrue);

      controller.toggleTimer();
      expect(controller.state.isRunning, isFalse);
    });

    test('resetInterval restores initial interval duration in paused state', () {
      controller.startTimer();
      controller.resetInterval();

      expect(controller.state.isRunning, isFalse);
      expect(controller.state.remainingSeconds, 1500);
      expect(controller.state.totalSeconds, 1500);
      expect(controller.state.formattedRemainingTime, '25:00');
    });

    test('selectIntervalType updates interval duration and resets timer', () {
      controller.selectIntervalType(PomodoroIntervalType.shortBreak);

      expect(controller.state.intervalType, PomodoroIntervalType.shortBreak);
      expect(controller.state.totalSeconds, 300);
      expect(controller.state.remainingSeconds, 300);
      expect(controller.state.formattedRemainingTime, '05:00');
      expect(controller.state.formattedTotalTime, 'de 05:00 min');
      expect(controller.state.isRunning, isFalse);

      controller.selectIntervalType(PomodoroIntervalType.longBreak);
      expect(controller.state.intervalType, PomodoroIntervalType.longBreak);
      expect(controller.state.totalSeconds, 900);
      expect(controller.state.remainingSeconds, 900);
      expect(controller.state.formattedRemainingTime, '15:00');
    });

    test('skipInterval transitions between focus and breaks with cycle management', () {
      // De foco en ciclo 2 a descanso corto en ciclo 2
      controller.skipInterval();
      expect(controller.state.intervalType, PomodoroIntervalType.shortBreak);
      expect(controller.state.currentCycle, 2);

      // De descanso corto en ciclo 2 a foco en ciclo 3
      controller.skipInterval();
      expect(controller.state.intervalType, PomodoroIntervalType.focus);
      expect(controller.state.currentCycle, 3);
    });

    test('updateObjective updates academic goal text cleanly', () {
      controller.updateObjective('Preparar informe de Laboratorio 3');
      expect(controller.state.currentObjective, 'Preparar informe de Laboratorio 3');

      // Si es vacío o solo espacios, se ignora o restaura default
      controller.updateObjective('   ');
      expect(controller.state.currentObjective, 'Preparar informe de Laboratorio 3');
    });

    test('toggleSoundscapeTrack switches track and toggles play/pause on same track', () {
      // Pista inicial: rain, playing: true
      expect(controller.state.selectedSoundscapeId, 'rain');
      expect(controller.state.isSoundscapePlaying, isTrue);

      // Tocar la misma pista activa la conmuta (pausa)
      controller.toggleSoundscapeTrack('rain');
      expect(controller.state.isSoundscapePlaying, isFalse);

      // Tocarla de nuevo la reanuda
      controller.toggleSoundscapeTrack('rain');
      expect(controller.state.isSoundscapePlaying, isTrue);

      // Tocar otra pista cambia la selección y activa reproducción
      controller.toggleSoundscapeTrack('cafe');
      expect(controller.state.selectedSoundscapeId, 'cafe');
      expect(controller.state.isSoundscapePlaying, isTrue);
    });

    test('setSoundscapeVolume clamps volume between 0.0 and 1.0', () {
      controller.setSoundscapeVolume(0.45);
      expect(controller.state.soundscapeVolume, 0.45);

      controller.setSoundscapeVolume(1.5);
      expect(controller.state.soundscapeVolume, 1.0);

      controller.setSoundscapeVolume(-0.2);
      expect(controller.state.soundscapeVolume, 0.0);
    });

    test('toggleDeepFocus updates deep focus flag', () {
      controller.toggleDeepFocus(false);
      expect(controller.state.isDeepFocusEnabled, isFalse);

      controller.toggleDeepFocus(true);
      expect(controller.state.isDeepFocusEnabled, isTrue);
    });
  });
}

